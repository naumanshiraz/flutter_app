import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/domain/repositories/invoice_repository.dart';

class GetInvoicesUseCase {
  final InvoiceRepository _repository;
  const GetInvoicesUseCase(this._repository);

  Future<Result<List<InvoiceSummary>>> call(String propertyId) => _repository.getInvoices(propertyId);
}

class GetInvoiceDetailUseCase {
  final InvoiceRepository _repository;
  const GetInvoiceDetailUseCase(this._repository);

  Future<Result<InvoiceDetail>> call(String invoiceId) => _repository.getInvoiceDetail(invoiceId);
}
