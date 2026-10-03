import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_remote_datasource.dart';
import 'package:pms_app/features/main_home/data/models/visitor_model.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/domain/repositories/visitor_repository.dart';

class VisitorRepositoryImpl implements VisitorRepository {
  final VisitorRemoteDataSource remote;

  VisitorRepositoryImpl({required this.remote});

  @override
  Future<Result<List<VisitorSchedule>>> getSchedules({required String householdId}) async {
    try {
      final remoteModels = await remote.getSchedules(householdId: householdId);
      return Success(remoteModels.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load visitor schedules: $e'));
    }
  }

  @override
  Future<Result<void>> addOrUpdateSchedule(VisitorSchedule schedule) async {
    final model = VisitorModel.fromEntity(schedule);
    try {
      await remote.addOrUpdateSchedule(model);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to save schedule: $e'));
    }
  }

  @override
  Future<Result<void>> deleteSchedule(String id) async {
    try {
      await remote.deleteSchedule(id);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete schedule: $e'));
    }
  }
}
