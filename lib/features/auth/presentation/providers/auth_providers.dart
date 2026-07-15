import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:pms_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pms_app/features/auth/data/repositories/auth_flow_repository_impl.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';
import 'package:pms_app/features/auth/domain/usecases/complete_auth_usecases.dart';
import 'package:pms_app/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:pms_app/features/auth/domain/usecases/verify_otp_usecase.dart';

/// Feature-scoped DI graph for Login / OTP / Sign-up-onboarding.
/// Presentation only ever reads the four `*UseCaseProvider`s below.

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageServiceProvider),
    localStorage: ref.watch(localStorageServiceProvider),
  );
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final authFlowRepositoryProvider = Provider<AuthFlowRepository>((ref) {
  return AuthFlowRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

final requestOtpUseCaseProvider = Provider<RequestOtpUseCase>((ref) {
  return RequestOtpUseCase(ref.watch(authFlowRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  return VerifyOtpUseCase(ref.watch(authFlowRepositoryProvider));
});

final completeLoginUseCaseProvider = Provider<CompleteLoginUseCase>((ref) {
  return CompleteLoginUseCase(ref.watch(authFlowRepositoryProvider));
});

final completeSignupUseCaseProvider = Provider<CompleteSignupUseCase>((ref) {
  return CompleteSignupUseCase(ref.watch(authFlowRepositoryProvider));
});
