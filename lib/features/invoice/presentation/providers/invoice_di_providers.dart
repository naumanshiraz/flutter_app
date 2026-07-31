import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/invoice/data/datasources/invoice_local_datasource.dart';
import 'package:pms_app/features/invoice/data/datasources/invoice_remote_datasource.dart';
import 'package:pms_app/features/invoice/data/repositories/invoice_repository_impl.dart';
import 'package:pms_app/features/invoice/domain/repositories/invoice_repository.dart';
import 'package:pms_app/features/invoice/domain/usecases/invoice_usecases.dart';

final invoiceLocalDataSourceProvider = Provider<InvoiceLocalDataSource>((ref) {
  return InvoiceLocalDataSourceImpl();
});

final invoiceRemoteDataSourceProvider = Provider<InvoiceRemoteDataSource>((ref) {
  return InvoiceRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(
    localDataSource: ref.watch(invoiceLocalDataSourceProvider),
    remoteDataSource: ref.watch(invoiceRemoteDataSourceProvider),
  );
});

final getInvoicesUseCaseProvider = Provider<GetInvoicesUseCase>((ref) {
  return GetInvoicesUseCase(ref.watch(invoiceRepositoryProvider));
});

final getInvoiceDetailUseCaseProvider = Provider<GetInvoiceDetailUseCase>((ref) {
  return GetInvoiceDetailUseCase(ref.watch(invoiceRepositoryProvider));
});
