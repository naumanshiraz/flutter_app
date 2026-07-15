import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:pms_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pms_app/features/auth/data/models/otp_session_model.dart';
import 'package:pms_app/features/auth/data/models/user_profile_model.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class AuthFlowRepositoryImpl implements AuthFlowRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  AuthFlowRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _connectivityService = connectivityService;

  @override
  Future<Result<OtpSession>> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  }) async {
    try {
      final isOnline = await _connectivityService.isConnected;
      AppLogger.info('AuthFlowRepository: requestOtp connectivity=$isOnline');
      // Mocked flow works fully offline today; once real API calls are
      // enabled above, an explicit `if (!isOnline) return ResultError(NetworkFailure())`
      // guard belongs here.

      final model = await _remoteDataSource.requestOtp(
        identifier: identifier,
        identifierType: identifierType,
        purpose: purpose,
      );
      await _localDataSource.savePendingOtpSession(model);
      return Success(model.toEntity());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to request OTP: $e'));
    }
  }

  @override
  Future<Result<bool>> verifyOtp({
    required String identifier,
    required String code,
  }) async {
    try {
      final pending = _localDataSource.getPendingOtpSession(identifier);
      if (pending == null) {
        return const ResultError(
          ServerFailure('No pending verification for this identifier. Please request a new code.'),
        );
      }
      if (DateTime.now().isAfter(pending.expiresAt)) {
        return const ResultError(ServerFailure('This code has expired. Please request a new one.'));
      }
      if (pending.code != code) {
        return const ResultError(ServerFailure('Incorrect code. Please try again.'));
      }

      // Round-trips through the (mocked) remote call too, so the real
      // API integration point is already exercised end-to-end.
      await _remoteDataSource.verifyOtp(identifier: identifier, code: code);
      await _localDataSource.clearPendingOtpSession();
      return const Success(true);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return ResultError(UnauthorizedFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to verify OTP: $e'));
    }
  }

  @override
  Future<Result<void>> completeLogin(String identifier) async {
    try {
      await _localDataSource.persistAuthenticatedSession();
      return const Success(null);
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to complete login: $e'));
    }
  }

  @override
  Future<Result<void>> completeSignup(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      await _remoteDataSource.submitSignupProfile(model);
      await _localDataSource.persistOnboardingProfile(model);
      await _localDataSource.persistAuthenticatedSession();
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to complete sign up: $e'));
    }
  }
}
