import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/splash/data/datasources/auth_local_datasource.dart';
import 'package:pms_app/features/splash/data/datasources/auth_remote_datasource.dart';
import 'package:pms_app/features/splash/data/repositories/auth_repository_impl.dart';
import 'package:pms_app/features/splash/domain/repositories/auth_repository.dart';
import 'package:pms_app/features/splash/domain/usecases/check_auth_session_usecase.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageServiceProvider),
    localStorage: ref.watch(localStorageServiceProvider),
  );
});

/// Wired up and ready even though nothing calls it yet — flip the
/// repository implementation to use it once a real backend exists.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    localDataSource: ref.watch(authLocalDataSourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

final checkAuthSessionUseCaseProvider = Provider<CheckAuthSessionUseCase>((ref) {
  return CheckAuthSessionUseCase(ref.watch(authRepositoryProvider));
});
