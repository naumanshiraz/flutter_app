import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/main_home/data/models/control_model.dart';

abstract class MainHomeRemoteDataSource {
  Future<List<ControlModel>> getControls({String? householdId});
  Future<void> toggleControl(String id, bool newState);
}

class MainHomeRemoteDataSourceImpl implements MainHomeRemoteDataSource {
  final Dio _dio;

  MainHomeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ControlModel>> getControls({String? householdId}) async {
    try {
      if (householdId == null) return const [];

      // ---- LIVE API: GET /api/app/households/{householdId}/devices ---
      final response = await _dio.get(AppConstants.endpointHouseholdDevices(householdId));
      final data = response.data as List<dynamic>;
      return data.map((j) => ControlModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch controls from server.');
    } catch (e) {
      throw ServerException('Unexpected error fetching controls: $e');
    }
  }

  @override
  Future<void> toggleControl(String id, bool newState) async {
    try {
      await _dio.post('/api/app/devices/$id/toggle', data: {'state': newState});
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to toggle control on server.');
    } catch (e) {
      throw ServerException('Unexpected error toggling control: $e');
    }
  }
}
