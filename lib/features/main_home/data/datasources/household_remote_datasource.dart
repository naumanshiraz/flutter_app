import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/network/dio_client.dart';
import 'package:pms_app/features/main_home/data/models/household_model.dart';

abstract class HouseholdRemoteDataSource {
  Future<List<HouseholdModel>> getHouseholds({
    required String campusId,
    String query = '',
    int limit = 50,
    int offset = 0,
  });
}

class HouseholdRemoteDataSourceImpl implements HouseholdRemoteDataSource {
  final Dio _dio;
  HouseholdRemoteDataSourceImpl(this._dio);

  @override
  Future<List<HouseholdModel>> getHouseholds({
    required String campusId,
    String query = '',
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // ---- LIVE API: GET /api/app/households?project_id={campusId} ----
      final response = await _dio.get(
        AppConstants.endpointHouseholds,
        queryParameters: campusId.trim().isEmpty ? null : {'project_id': campusId},
      );
      final rows = response.data as List<dynamic>;
      final households = rows.map((row) => HouseholdModel.fromJson(row as Map<String, dynamic>)).toList();
      return campusId.trim().isEmpty ? households.take(10).toList() : households;
    } on DioException catch (e) {
      final serverMessage = e.response?.data is Map
          ? (e.response?.data as Map)['message']?.toString()
          : null;
      final appErrorMessage = e.error is AppException ? (e.error as AppException).userMessage : null;
      throw ServerException(serverMessage ?? appErrorMessage ?? e.message ?? 'Failed to load households.');
    } catch (e) {
      throw ServerException('Unexpected error loading households: $e');
    }
  }
}
