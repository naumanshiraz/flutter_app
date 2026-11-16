import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';

abstract class InvoiceRepository {
  Future<Result<List<InvoiceSummary>>> getInvoices(String householdId);
  Future<Result<InvoiceDetail>> getInvoiceDetail(String invoiceId);
  Future<Result<String>> getInvoicePdfUrl(String invoiceId);
}
