import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_local_datasource.dart';
import 'package:pms_app/features/main_home/data/models/visitor_model.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/domain/repositories/visitor_repository.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  final VisitorLocalDataSource local;

  VisitorRepositoryImpl({required this.local});

  @override
  Future<Result<List<VisitorSchedule>>> getSchedules() async {
    try {
      final models = await local.getSchedules();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load visitor schedules: $e'));
    }
  }

  @override
  Future<Result<void>> addOrUpdateSchedule(VisitorSchedule schedule) async {
    try {
      await local.addOrUpdateSchedule(VisitorModel.fromEntity(schedule));
      return const Success(null);
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to save schedule: $e'));
    }
  }

  @override
  Future<Result<void>> deleteSchedule(String id) async {
    try {
      await local.deleteSchedule(id);
      return const Success(null);
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete schedule: $e'));
    }
  }
}