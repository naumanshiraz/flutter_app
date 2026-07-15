import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/splash/data/datasources/auth_local_datasource.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';
import 'package:pms_app/features/splash/domain/repositories/auth_repository.dart';

/// Concrete implementation used TODAY (mocked data / local-only).
///
/// API-ready note: once a backend exists, inject [AuthRemoteDataSource]
/// here too and, when `connectivity.isConnected` is true, call
/// `remote.validateSession(token)` to refresh the session server-side
/// before returning it. The Domain/Presentation layers require zero
/// changes for that upgrade.
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final ConnectivityService _connectivityService;

  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required ConnectivityService connectivityService,
  })  : _localDataSource = localDataSource,
        _connectivityService = connectivityService;

  @override
  Future<Result<AuthSession>> getCurrentSession() async {
    try {
      // Connectivity is checked (and logged) even though Module 1 is
      // fully local/mocked, so the app-initialization flow already
      // exercises the real connectivity path future modules will rely on.
      final connected = await _connectivityService.isConnected;
      AppLogger.info('AuthRepository: device connectivity = $connected');

      final model = await _localDataSource.getLocalSession();
      return Success(model.toEntity());
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to resolve auth session: $e'));
    }
  }
}
