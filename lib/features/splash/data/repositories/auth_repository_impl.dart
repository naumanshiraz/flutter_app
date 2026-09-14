import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/splash/data/datasources/auth_remote_datasource.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';
import 'package:pms_app/features/splash/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;
  final ConnectivityService _connectivityService;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
    required ConnectivityService connectivityService,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage,
        _localStorage = localStorage,
        _connectivityService = connectivityService;

  @override
  Future<Result<AuthSession>> getCurrentSession() async {
    try {
      final connected = await _connectivityService.isConnected;
      AppLogger.info('AuthRepository: device connectivity = $connected');
      if (!connected) {
        return const ResultError(NetworkFailure());
      }

      final token = await _secureStorage.getAuthToken();
      final loggedInLocally = _localStorage.isLoggedIn;
      if (token == null || token.isEmpty || !loggedInLocally) {
        return Success(AuthSession.guest());
      }

      try {
        final userId = await _remoteDataSource.fetchCurrentUserId(token);
        return Success(AuthSession(
          isAuthenticated: true,
          userId: userId,
          onboardingComplete: _localStorage.onboardingComplete,
        ));
      } on UnauthorizedException {
        AppLogger.warning('AuthRepository: /api/auth/me returned 401. Clearing local session.');
        await _secureStorage.clearAll();
        await _localStorage.setLoggedIn(false);
        await _localStorage.clearUserData();
        return Success(AuthSession.guest());
      }
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to resolve auth session: $e'));
    }
  }
}
