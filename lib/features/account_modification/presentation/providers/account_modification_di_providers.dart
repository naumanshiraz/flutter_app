import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/account_modification/data/datasources/account_modification_remote_datasource.dart';
import 'package:pms_app/features/account_modification/data/repositories/account_modification_repository_impl.dart';
import 'package:pms_app/features/account_modification/domain/repositories/account_modification_repository.dart';
import 'package:pms_app/features/account_modification/domain/usecases/update_admin_identifier_usecase.dart';

final accountModificationRemoteDataSourceProvider = Provider<AccountModificationRemoteDataSource>((ref) {
  return AccountModificationRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final accountModificationRepositoryProvider = Provider<AccountModificationRepository>((ref) {
  return AccountModificationRepositoryImpl(
    remoteDataSource: ref.watch(accountModificationRemoteDataSourceProvider),
  );
});

final updateAdminIdentifierUseCaseProvider = Provider<UpdateAdminIdentifierUseCase>((ref) {
  return UpdateAdminIdentifierUseCase(ref.watch(accountModificationRepositoryProvider));
});
