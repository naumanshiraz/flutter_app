import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/invoice/data/models/invoice_model.dart';

abstract class InvoiceLocalDataSource {
  Future<List<InvoiceSummaryModel>> fetchInvoices(String propertyId);
  Future<InvoiceDetailModel> fetchInvoiceDetail(String invoiceId);
}

class InvoiceLocalDataSourceImpl implements InvoiceLocalDataSource {
  @override
  Future<List<InvoiceSummaryModel>> fetchInvoices(String propertyId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return const [];
    } catch (e) {
      throw CacheException('Failed to read cached invoices: $e');
    }
  }

  @override
  Future<InvoiceDetailModel> fetchInvoiceDetail(String invoiceId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      throw CacheException('No cached invoice for $invoiceId');
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException('Failed to read cached invoice: $e');
    }
  }
}
