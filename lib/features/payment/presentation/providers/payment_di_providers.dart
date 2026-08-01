import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/payment/data/datasources/payment_local_datasource.dart';
import 'package:pms_app/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:pms_app/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:pms_app/features/payment/domain/repositories/payment_repository.dart';
import 'package:pms_app/features/payment/domain/usecases/get_payment_methods_usecase.dart';

final paymentLocalDataSourceProvider = Provider<PaymentLocalDataSource>((ref) {
  return PaymentLocalDataSourceImpl();
});

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepositoryImpl(
    localDataSource: ref.watch(paymentLocalDataSourceProvider),
    remoteDataSource: ref.watch(paymentRemoteDataSourceProvider),
  );
});

final getPaymentMethodsUseCaseProvider = Provider<GetPaymentMethodsUseCase>((ref) {
  return GetPaymentMethodsUseCase(ref.watch(paymentRepositoryProvider));
});
