import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource _remoteDataSource;

  InvoiceRepositoryImpl({required InvoiceRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<InvoiceSummary>>> getInvoices(String householdId) async {
    try {
      final models = await _remoteDataSource.getInvoices(householdId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load invoices: $e'));
    }
  }

  @override
  Future<Result<InvoiceDetail>> getInvoiceDetail(String invoiceId) async {
    try {
      final model = await _remoteDataSource.getInvoiceDetail(invoiceId);
      return Success(model.toEntity());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load invoice: $e'));
    }
  }

  @override
  Future<Result<String>> getInvoicePdfUrl(String invoiceId) async {
    try {
      return Success(await _remoteDataSource.getInvoicePdfUrl(invoiceId));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to open invoice PDF: $e'));
    }
  }
}
