import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_local_datasource.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_remote_datasource.dart';
import 'package:pms_app/features/main_home/data/models/visitor_model.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/domain/repositories/visitor_repository.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  final VisitorLocalDataSource local;
  final VisitorRemoteDataSource remote;

  VisitorRepositoryImpl({required this.local, required this.remote});

  @override
  Future<Result<List<VisitorSchedule>>> getSchedules() async {
    try {
      // Try remote first
      final remoteModels = await remote.getSchedules();
      final entities = remoteModels.map((m) => m.toEntity()).toList();

      // Sync remote into local for offline reads
      for (final m in remoteModels) {
        await local.addOrUpdateSchedule(m);
      }

      return Success(entities);
    } on ServerException catch (_) {
      // Remote failed — try local
      try {
        final localModels = await local.getSchedules();
        return Success(localModels.map((m) => m.toEntity()).toList());
      } on CacheException catch (e) {
        return ResultError(CacheFailure(e.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load visitor schedules: $e'));
      }
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load visitor schedules: $e'));
    }
  }

  @override
  Future<Result<void>> addOrUpdateSchedule(VisitorSchedule schedule) async {
    final model = VisitorModel.fromEntity(schedule);
    try {
      // Try remote; on success persist local
      await remote.addOrUpdateSchedule(model);
      await local.addOrUpdateSchedule(model);
      return const Success(null);
    } on ServerException catch (e) {
      // Persist locally anyway so user doesn't lose data
      try {
        await local.addOrUpdateSchedule(model);
        return ResultError(ServerFailure(e.message));
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e2) {
        return ResultError(UnknownFailure('Failed to save schedule: $e2'));
      }
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to save schedule: $e'));
    }
  }

  @override
  Future<Result<void>> deleteSchedule(String id) async {
    try {
      await remote.deleteSchedule(id);
      await local.deleteSchedule(id);
      return const Success(null);
    } on ServerException catch (e) {
      // Try local delete even if remote fails
      try {
        await local.deleteSchedule(id);
        return ResultError(ServerFailure(e.message));
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e2) {
        return ResultError(UnknownFailure('Failed to delete schedule: $e2'));
      }
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete schedule: $e'));
    }
  }
}