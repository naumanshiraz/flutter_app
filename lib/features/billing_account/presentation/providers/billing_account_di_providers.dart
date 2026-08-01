import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/billing_account/data/datasources/billing_account_local_datasource.dart';
import 'package:pms_app/features/billing_account/data/datasources/billing_account_remote_datasource.dart';
import 'package:pms_app/features/billing_account/data/repositories/billing_account_repository_impl.dart';
import 'package:pms_app/features/billing_account/domain/repositories/billing_account_repository.dart';
import 'package:pms_app/features/billing_account/domain/usecases/submit_billing_account_usecase.dart';

final billingAccountLocalDataSourceProvider = Provider<BillingAccountLocalDataSource>((ref) {
  return BillingAccountLocalDataSourceImpl();
});

final billingAccountRemoteDataSourceProvider = Provider<BillingAccountRemoteDataSource>((ref) {
  return BillingAccountRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final billingAccountRepositoryProvider = Provider<BillingAccountRepository>((ref) {
  return BillingAccountRepositoryImpl(
    localDataSource: ref.watch(billingAccountLocalDataSourceProvider),
    remoteDataSource: ref.watch(billingAccountRemoteDataSourceProvider),
  );
});

final submitBillingAccountUseCaseProvider = Provider<SubmitBillingAccountUseCase>((ref) {
  return SubmitBillingAccountUseCase(ref.watch(billingAccountRepositoryProvider));
});
