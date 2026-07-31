import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/invoice/data/datasources/invoice_local_datasource.dart';
import 'package:pms_app/features/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/domain/repositories/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceLocalDataSource _localDataSource;
  final InvoiceRemoteDataSource _remoteDataSource;

  InvoiceRepositoryImpl({
    required InvoiceLocalDataSource localDataSource,
    required InvoiceRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<InvoiceSummary>>> getInvoices(String propertyId) async {
    try {
      final models = await _remoteDataSource.getInvoices(propertyId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (_) {
      try {
        final local = await _localDataSource.fetchInvoices(propertyId);
        return Success(local.map((m) => m.toEntity()).toList());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load invoices: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load invoices: $e'));
    }
  }

  @override
  Future<Result<InvoiceDetail>> getInvoiceDetail(String invoiceId) async {
    try {
      final model = await _remoteDataSource.getInvoiceDetail(invoiceId);
      return Success(model.toEntity());
    } on ServerException catch (_) {
      try {
        final local = await _localDataSource.fetchInvoiceDetail(invoiceId);
        return Success(local.toEntity());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load invoice: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load invoice: $e'));
    }
  }
}
