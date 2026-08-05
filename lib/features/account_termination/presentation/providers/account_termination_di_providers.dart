import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/account_termination/data/datasources/account_termination_remote_datasource.dart';
import 'package:pms_app/features/account_termination/data/repositories/account_termination_repository_impl.dart';
import 'package:pms_app/features/account_termination/domain/repositories/account_termination_repository.dart';
import 'package:pms_app/features/account_termination/domain/usecases/terminate_account_usecase.dart';

final accountTerminationRemoteDataSourceProvider = Provider<AccountTerminationRemoteDataSource>((ref) {
  return AccountTerminationRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final accountTerminationRepositoryProvider = Provider<AccountTerminationRepository>((ref) {
  return AccountTerminationRepositoryImpl(
    remoteDataSource: ref.watch(accountTerminationRemoteDataSourceProvider),
  );
});

final terminateAccountUseCaseProvider = Provider<TerminateAccountUseCase>((ref) {
  return TerminateAccountUseCase(ref.watch(accountTerminationRepositoryProvider));
});
