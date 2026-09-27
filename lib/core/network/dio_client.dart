import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';

enum AppErrorType {
  noInternet,
  dnsOrHostUnreachable,
  timeout,
  serverError,
  badRequest,
  cancelled,
  unknown,
}

class AppException implements Exception {
  final AppErrorType type;
  final String message;
  final int? statusCode;

  AppException(this.type, this.message, {this.statusCode});

  String get userMessage {
    switch (type) {
      case AppErrorType.noInternet:
        return "No internet connection. Please check your network.";
      case AppErrorType.dnsOrHostUnreachable:
        return "Network is unstable. Please try again.";
      case AppErrorType.timeout:
        return "The request timed out. Please try again.";
      case AppErrorType.serverError:
        return "Something went wrong on our end. Please try again later.";
      case AppErrorType.badRequest:
        return message.isNotEmpty ? message : "Invalid request.";
      case AppErrorType.cancelled:
        return "Request cancelled.";
      case AppErrorType.unknown:
        return "Unexpected error occurred. Please try again.";
    }
  }

  @override
  String toString() => 'AppException($type, $message)';

  static AppException fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(AppErrorType.timeout, e.message ?? 'Timeout');

      case DioExceptionType.cancel:
        return AppException(AppErrorType.cancelled, 'Cancelled');

      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return AppException(
            AppErrorType.dnsOrHostUnreachable,
            'DNS/host lookup failed',
          );
        }
        return AppException(
          AppErrorType.dnsOrHostUnreachable,
          e.message ?? 'Connection error',
        );

      case DioExceptionType.badResponse:
        final status = e.response?.statusCode ?? 0;
        if (status >= 500) {
          return AppException(AppErrorType.serverError, 'Server error',
              statusCode: status);
        }
        return AppException(
          AppErrorType.badRequest,
          e.response?.data?['message']?.toString() ?? 'Bad request',
          statusCode: status,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        return AppException(AppErrorType.unknown, e.message ?? 'Unknown error');
    }
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelays = const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
    ],
  });

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final currentAttempt = requestOptions.extra['retry_attempt'] ?? 0;

    if (_shouldRetry(err) && currentAttempt < retries) {
      final attempt = currentAttempt + 1;
      final delay = retryDelays[(attempt - 1).clamp(0, retryDelays.length - 1)];

      await Future.delayed(delay);
      requestOptions.extra['retry_attempt'] = attempt;

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    return handler.next(err);
  }
}

class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    final hasConnection = connectivityResult.isNotEmpty &&
        !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: AppException(
            AppErrorType.noInternet,
            'No internet connection',
          ),
        ),
      );
    }

    return handler.next(options);
  }
}
class DioClient {
  final Dio dio;
  final SecureStorageService _secureStorage;

  DioClient({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage,
        dio = Dio(
          BaseOptions(
            baseUrl: AppConstants.baseUrl,
            connectTimeout: AppConstants.apiTimeout,
            receiveTimeout: AppConstants.apiTimeout,
            sendTimeout: AppConstants.apiTimeout,
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.addAll([
      ConnectivityInterceptor(),

      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),

      RetryInterceptor(dio: dio),

      InterceptorsWrapper(
        onError: (DioException error, handler) {
          AppLogger.error(
            'Dio error: ${error.requestOptions.path}',
            error,
          );

          final appError = error.error is AppException
              ? error.error as AppException
              : AppException.fromDioException(error);

          return handler.next(
            DioException(
              requestOptions: error.requestOptions,
              error: appError,
              type: error.type,
              response: error.response,
            ),
          );
        },
      ),
    ]);
  }
}
