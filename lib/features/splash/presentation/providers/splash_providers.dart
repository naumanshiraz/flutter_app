import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/splash/data/datasources/auth_remote_datasource.dart';
import 'package:pms_app/features/splash/data/repositories/auth_repository_impl.dart';
import 'package:pms_app/features/splash/domain/repositories/auth_repository.dart';
import 'package:pms_app/features/splash/domain/usecases/check_auth_session_usecase.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorage: ref.watch(secureStorageServiceProvider),
    localStorage: ref.watch(localStorageServiceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

final checkAuthSessionUseCaseProvider = Provider<CheckAuthSessionUseCase>((ref) {
  return CheckAuthSessionUseCase(ref.watch(authRepositoryProvider));
});
