import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/invoice/data/models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceSummaryModel>> getInvoices(String propertyId);
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio _dio;
  InvoiceRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockInvoices = [
    {'id': 'inv-2024-05', 'label': 'May 5, 2024 - Invoice', 'status': 'pending'},
    {'id': 'inv-2024-04', 'label': 'April 5, 2024 - Invoice', 'status': 'overdue'},
    {'id': 'inv-2024-03', 'label': 'March 5, 2024 - Invoice', 'status': 'none'},
  ];

  static const Map<String, Map<String, dynamic>> _mockDetails = {
    'inv-2024-05': {
      'id': 'inv-2024-05',
      'label': 'May 5, 2024 - Invoice',
      'propertyName': 'Khos urguu',
      'propertyAddress': '85 - 2, Gerlug Vista\n15th Khoroo, Khan Uul\nUB, Mongolia 13146',
      'date': 'May 5, 2024',
      'dueDate': 'May 20, 2024',
      'invoiceNumber': '050524',
      'billToName': 'Tulgabaatar Dashdorj',
      'billToAddress': '85 - 75, Gerlug Vista\n15th Khoroo, Khan Uul\nUB, Mongolia 13146',
      'balanceDue': 'MNT 45,000',
      'charges': [
        {'label': 'Maintenance & repairs', 'amount': 'MNT 15,000'},
        {'label': 'Cleaning fees', 'amount': 'MNT 10,000'},
        {'label': 'Inspection and background checks', 'amount': 'MNT 5,000'},
        {'label': 'Management fee', 'amount': 'MNT 5,000'},
        {'label': 'Security', 'amount': 'MNT 5,000'},
        {'label': 'Insurance', 'amount': 'MNT 5,000'},
        {'label': 'Overdue penalty', 'amount': '-'},
      ],
    },
  };

  @override
  Future<List<InvoiceSummaryModel>> getInvoices(String propertyId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockInvoices.map(InvoiceSummaryModel.fromJson).toList();

      // final response = await _dio.get('/properties/$propertyId/invoices');
      // final data = response.data as List<dynamic>;
      // return data.map((j) => InvoiceSummaryModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch invoices.');
    } catch (e) {
      throw ServerException('Unexpected error fetching invoices: $e');
    }
  }

  @override
  Future<InvoiceDetailModel> getInvoiceDetail(String invoiceId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final json = _mockDetails[invoiceId];
      if (json == null) throw ServerException('Invoice not found: $invoiceId');
      return InvoiceDetailModel.fromJson(json);

      // final response = await _dio.get('/invoices/$invoiceId');
      // return InvoiceDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch invoice.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error fetching invoice: $e');
    }
  }
}
