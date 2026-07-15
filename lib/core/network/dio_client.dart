import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';

/// Centralized Dio instance. Not exercised by Module 1 (no backend yet),
/// but wired up so RemoteDataSources across every future module can just
/// inject this and start making real calls with zero refactor.
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
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.getAuthToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          AppLogger.error('Dio error: ${error.requestOptions.path}', error);
          return handler.next(error);
        },
      ),
    );
  }
}
