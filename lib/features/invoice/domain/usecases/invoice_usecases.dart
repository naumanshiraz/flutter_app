import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/domain/repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository _repository;
  const GetInvoicesUseCase(this._repository);

  Future<Result<List<InvoiceSummary>>> call(String householdId) => _repository.getInvoices(householdId);
}

class GetInvoiceDetailUseCase {
  final InvoiceRepository _repository;
  const GetInvoiceDetailUseCase(this._repository);

  Future<Result<InvoiceDetail>> call(String invoiceId) => _repository.getInvoiceDetail(invoiceId);
}

class DownloadInvoicePdfUseCase {
  final InvoiceRepository _repository;
  const DownloadInvoicePdfUseCase(this._repository);

  Future<Result<String>> call(String invoiceId) => _repository.downloadInvoicePdf(invoiceId);
}
