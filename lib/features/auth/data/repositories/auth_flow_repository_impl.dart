import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:pms_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:pms_app/features/auth/data/models/user_profile_model.dart';
import 'package:pms_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class AuthFlowRepositoryImpl implements AuthFlowRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;
  final ConnectivityService _connectivityService;

  AuthTokensModel? _pendingTokens;

  AuthFlowRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
    required ConnectivityService connectivityService,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage,
        _localStorage = localStorage,
        _connectivityService = connectivityService;

  String _serverPurpose(OtpPurpose purpose) =>
      purpose == OtpPurpose.signup ? 'signup' : 'login';

  Future<void> _persistSession(AuthTokensModel tokens) async {
    await _secureStorage.saveAuthToken(tokens.token);
    await _secureStorage.saveRefreshToken(tokens.refreshToken);
    await _localStorage.setLoggedIn(true);
    await _localStorage.setOnboardingComplete(tokens.onboardingComplete);
  }

  @override
  Future<Result<OtpSession>> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  }) async {
    try {
      final isOnline = await _connectivityService.isConnected;
      AppLogger.info('AuthFlowRepository: requestOtp connectivity=$isOnline');
      if (!isOnline) {
        return const ResultError(NetworkFailure());
      }

      final model = await _remoteDataSource.requestOtp(
        identifier: identifier,
        purpose: _serverPurpose(purpose),
      );
      return Success(model.toEntity(identifierType: identifierType, purpose: purpose));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to request OTP: $e'));
    }
  }

  @override
  Future<Result<AuthTokens>> verifyOtp({
    required String identifier,
    required String code,
  }) async {
    try {
      final model = await _remoteDataSource.verifyOtp(identifier: identifier, code: code);
      _pendingTokens = model;
      return Success(model.toEntity());
    } on UnauthorizedException catch (e) {
      return ResultError(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to verify OTP: $e'));
    }
  }

  @override
  Future<Result<void>> completeLogin() async {
    final tokens = _pendingTokens;
    if (tokens == null) {
      return const ResultError(
        ServerFailure('No verified session to complete. Please verify the code again.'),
      );
    }
    try {
      await _persistSession(tokens);
      _pendingTokens = null;
      return const Success(null);
    } catch (e) {
      return ResultError(CacheFailure('Failed to complete login: $e'));
    }
  }

  @override
  Future<Result<void>> completeSignup(UserProfile profile) async {
    if (profile.name.trim().isEmpty) {
      return const ResultError(ServerFailure('Full name is required.'));
    }

    final tokens = _pendingTokens;
    if (tokens == null) {
      return const ResultError(
        ServerFailure('No verified session to complete. Please verify the code again.'),
      );
    }
    try {
      await _persistSession(tokens);

      final model = UserProfileModel.fromEntity(profile);
      final saved = await _remoteDataSource.submitSignupProfile(model);

      if (saved.onboardingComplete != tokens.onboardingComplete) {
        await _persistSession(tokens.copyWith(onboardingComplete: saved.onboardingComplete));
      }

      await _localStorage.setCachedUserProfileJson(jsonEncode(saved.toJson()));
      _pendingTokens = null;
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(CacheFailure('Failed to complete sign up: $e'));
    }
  }

  @override
  Future<Result<AuthTokens>> refreshSession(String refreshToken) async {
    try {
      final model = await _remoteDataSource.refreshSession(refreshToken);
      await _persistSession(model);
      return Success(model.toEntity());
    } on UnauthorizedException catch (e) {
      await _secureStorage.clearAll();
      await _localStorage.setLoggedIn(false);
      await _localStorage.clearUserData();
      return ResultError(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to refresh session: $e'));
    }
  }

  @override
  Future<Result<void>> logout(String refreshToken) async {
    try {
      await _remoteDataSource.logout(refreshToken);
    } catch (e) {
      AppLogger.warning('AuthFlowRepository: logout call failed ($e). Clearing session locally.');
    }
    try {
      await _secureStorage.clearAll();
      await _localStorage.setLoggedIn(false);
      await _localStorage.clearUserData();
      _pendingTokens = null;
      return const Success(null);
    } catch (e) {
      return ResultError(CacheFailure('Failed to clear session: $e'));
    }
  }
}
