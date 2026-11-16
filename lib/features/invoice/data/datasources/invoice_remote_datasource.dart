import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/invoice/data/models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceSummaryModel>> getInvoices(String householdId);
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId);
  Future<String> getInvoicePdfUrl(String invoiceId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio _dio;
  InvoiceRemoteDataSourceImpl(this._dio);

  static const int _limit = 50;

  ServerException _toServerException(DioException e, String fallback) {
    final data = e.response?.data;
    final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
    return ServerException(serverMessage ?? e.message ?? fallback);
  }

  /// LIVE: GET /api/app/households/{id}/invoices?limit=50
  @override
  Future<List<InvoiceSummaryModel>> getInvoices(String householdId) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointHouseholdInvoices(householdId),
        queryParameters: {'limit': _limit},
      );
      final body = response.data;
      final rows = body is List
          ? body
          : (body is Map ? (body['items'] ?? body['data'] ?? body['results']) : null);
      if (rows is! List) throw const ServerException('Unexpected invoices response.');
      return rows.map((j) => InvoiceSummaryModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _toServerException(e, 'Failed to fetch invoices.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error fetching invoices: $e');
    }
  }

  /// LIVE: GET /api/app/invoices/{id}
  @override
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId) async {
    try {
      final response = await _dio.get(AppConstants.endpointInvoice(invoiceId));
      return InvoiceDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _toServerException(e, 'Failed to fetch invoice.');
    } catch (e) {
      throw ServerException('Unexpected error fetching invoice: $e');
    }
  }

  /// LIVE: GET /api/app/invoices/{id}/pdf — resolved to a URL the browser can open.
  /// Handles a redirect (Location header) or a JSON body carrying a url.
  @override
  Future<String> getInvoicePdfUrl(String invoiceId) async {
    final path = AppConstants.endpointInvoicePdf(invoiceId);
    try {
      final response = await _dio.get<List<int>>(
        path,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (s) => s != null && s < 400,
        ),
      );
      final location = response.headers.value('location');
      if (location != null && location.isNotEmpty) {
        return response.requestOptions.uri.resolve(location).toString();
      }
      final type = response.headers.value('content-type') ?? '';
      if (type.contains('json')) {
        final json = jsonDecode(utf8.decode(response.data ?? const []));
        if (json is Map) {
          final url = json['url'] ?? json['pdf_url'] ?? json['download_url'];
          if (url is String && url.isNotEmpty) return url;
        }
        throw const ServerException('Invoice PDF link was not provided.');
      }
      // Raw PDF served directly from the endpoint.
      return response.requestOptions.uri.toString();
    } on DioException catch (e) {
      throw _toServerException(e, 'Failed to open invoice PDF.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error opening invoice PDF: $e');
    }
  }
}
