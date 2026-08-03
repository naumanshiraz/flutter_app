import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/splash/data/datasources/auth_local_datasource.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';
import 'package:pms_app/features/splash/domain/repositories/auth_repository.dart';

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
