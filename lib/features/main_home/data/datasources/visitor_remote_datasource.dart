import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/main_home/data/models/visitor_model.dart';

abstract class VisitorRemoteDataSource {
  Future<List<VisitorModel>> getSchedules({required String householdId});
  Future<void> addOrUpdateSchedule(VisitorModel model);
  Future<void> deleteSchedule(String id);
}

class VisitorRemoteDataSourceImpl implements VisitorRemoteDataSource {
  final Dio _dio;

  VisitorRemoteDataSourceImpl(this._dio);

  @override
  Future<List<VisitorModel>> getSchedules({required String householdId}) async {
    try {
      // ---- LIVE API: GET /api/app/households/{householdId}/visitors ---
      final resp = await _dio.get(AppConstants.endpointHouseholdVisitors(householdId));
      final data = resp.data as List<dynamic>;
      return data
          .map((j) => VisitorModel.fromJson(j as Map<String, dynamic>, householdId: householdId))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load visitor schedules from server.');
    } catch (e) {
      throw ServerException('Unexpected error loading visitor schedules: $e');
    }
  }

  @override
  Future<void> addOrUpdateSchedule(VisitorModel model) async {
    try {
      final isNew = model.id.isEmpty;
      if (isNew) {
        await _dio.post(AppConstants.endpointHouseholdVisitors(model.householdId), data: model.toJson());
      } else {
        await _dio.put(
          '${AppConstants.endpointHouseholdVisitors(model.householdId)}/${model.id}',
          data: model.toJson(),
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to save visitor schedule on server.');
    } catch (e) {
      throw ServerException('Unexpected error saving visitor schedule: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      await _dio.delete('/api/app/visitors/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete visitor schedule on server.');
    } catch (e) {
      throw ServerException('Unexpected error deleting visitor schedule: $e');
    }
  }
}
