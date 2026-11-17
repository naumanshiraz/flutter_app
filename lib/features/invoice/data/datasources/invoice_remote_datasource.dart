import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/invoice/data/models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceSummaryModel>> getInvoices(String householdId);
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId);
  
  Future<String> downloadInvoicePdf(String invoiceId);
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

  /// LIVE: GET /api/app/invoices/{id}/pdf
  @override
  Future<String> downloadInvoicePdf(String invoiceId) async {
    try {
      final response = await _dio.get<List<int>>(
        AppConstants.endpointInvoicePdf(invoiceId),
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      final isPdf = bytes != null &&
          bytes.length > 4 &&
          bytes[0] == 0x25 && // %
          bytes[1] == 0x50 && // P
          bytes[2] == 0x44 && // D
          bytes[3] == 0x46; // F
      if (!isPdf) throw const ServerException('Invoice PDF is not available.');

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/invoice-$invoiceId.pdf');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } on DioException catch (e) {
      throw _toServerException(e, 'Failed to download invoice PDF.');
    } on ServerException {
      rethrow;
    } on FileSystemException catch (e) {
      throw ServerException('Could not save invoice PDF: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error downloading invoice PDF: $e');
    }
  }
}
