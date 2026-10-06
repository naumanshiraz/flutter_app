import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/family_members/data/models/occupant_model.dart';

abstract class HouseholdMembersRemoteDataSource {
  Future<List<OccupantModel>> getMembers(String householdId);
}

class HouseholdMembersRemoteDataSourceImpl implements HouseholdMembersRemoteDataSource {
  final Dio _dio;

  HouseholdMembersRemoteDataSourceImpl(this._dio);

  @override
  Future<List<OccupantModel>> getMembers(String householdId) async {
    try {
      // ---- LIVE API: GET /api/app/households/{householdId}/members ----
      final response = await _dio.get(AppConstants.endpointHouseholdMembers(householdId));
      final rows = response.data as List<dynamic>;
      return rows.map((row) => OccupantModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load occupants.');
    } catch (e) {
      throw ServerException('Unexpected error loading occupants: $e');
    }
  }
}
