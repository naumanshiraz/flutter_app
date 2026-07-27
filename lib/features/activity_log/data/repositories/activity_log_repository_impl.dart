import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/activity_log/data/datasources/activity_log_local_datasource.dart';
import 'package:pms_app/features/activity_log/data/datasources/activity_log_remote_datasource.dart';
import 'package:pms_app/features/activity_log/domain/entities/log_entry.dart';
import 'package:pms_app/features/activity_log/domain/repositories/activity_log_repository.dart';

class ActivityLogRepositoryImpl implements ActivityLogRepository {
  final ActivityLogLocalDataSource _localDataSource;
  final ActivityLogRemoteDataSource _remoteDataSource;

  ActivityLogRepositoryImpl({
    required ActivityLogLocalDataSource localDataSource,
    required ActivityLogRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<LogEntry>>> getLogs() async {
    try {
      final models = await _remoteDataSource.getLogs();
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (_) {
      try {
        final local = await _localDataSource.fetchLogs();
        return Success(local.map((m) => m.toEntity()).toList());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load logs: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load logs: $e'));
    }
  }
}
