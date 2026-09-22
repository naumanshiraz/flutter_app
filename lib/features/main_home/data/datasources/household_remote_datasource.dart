import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
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

  // Mocked per-campus household lists (no backend yet), shaped exactly like
  // GET /api/app/campuses/{campusId}/households.
  static const Map<String, List<Map<String, dynamic>>> _mockHouseholds = {
    'gerlug-vista': [
      {
        'id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'suite': '100',
        'floor': 1,
        'unit_type': 'Residential',
        'claimed': false,
        'building_id': 'a8e50f37-81cf-4174-95ed-53c994ffa521',
        'building_name': '215B Block',
        'image_url': 'https://picsum.photos/seed/household-1/800/500',
      },
      {
        'id': 'b6f2a9a0-11d2-4d2a-9a2a-2f0a5b7f0c11',
        'suite': '201',
        'floor': 2,
        'unit_type': 'Residential',
        'claimed': true,
        'building_id': 'a8e50f37-81cf-4174-95ed-53c994ffa521',
        'building_name': '215B Block',
        'image_url': null,
      },
      {
        'id': '2c1e6a7a-3b3b-4a2e-8b9a-9e7f6a2d5c33',
        'suite': '305',
        'floor': 3,
        'unit_type': 'Commercial',
        'claimed': false,
        'building_id': 'e2b4c9d1-6a55-4a0e-9d4f-3c2b1a908f77',
        'building_name': '212A Tower',
        'image_url': 'https://picsum.photos/seed/household-3/800/500',
      },
      {
        'id': 'd9a3f5c2-7e1b-4b6d-9c1a-8f5e2d3b4a66',
        'suite': '410',
        'floor': 4,
        'unit_type': 'Residential',
        'claimed': false,
        'building_id': 'e2b4c9d1-6a55-4a0e-9d4f-3c2b1a908f77',
        'building_name': '212A Tower',
        'image_url': null,
      },
      {
        'id': '7b8c4e1a-2d3f-4a5b-8c6d-1e2f3a4b5c77',
        'suite': '512',
        'floor': 5,
        'unit_type': 'Residential',
        'claimed': true,
        'building_id': 'a8e50f37-81cf-4174-95ed-53c994ffa521',
        'building_name': '215B Block',
        'image_url': 'https://picsum.photos/seed/household-5/800/500',
      },
    ],
  };

  @override
  Future<List<HouseholdModel>> getHouseholds({
    required String campusId,
    String query = '',
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      // ---- MOCK (no backend yet) ------------------------------------
      await Future.delayed(const Duration(milliseconds: 700));
      final rows = _mockHouseholds[campusId] ?? _mockHouseholds['gerlug-vista']!;
      final filtered = query.trim().isEmpty
          ? rows
          : rows
              .where((r) => (r['building_name'] as String).toLowerCase().contains(query.toLowerCase()))
              .toList();
      final paged = filtered.skip(offset).take(limit).toList();
      return paged.map(HouseholdModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend is live) -------------
      // final response = await _dio.get(
      //   AppConstants.endpointCampusHouseholds(campusId),
      //   queryParameters: {'q': query, 'limit': limit, 'offset': offset},
      // );
      // final rows = response.data as List<dynamic>;
      // return rows.map((row) => HouseholdModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load households.');
    } catch (e) {
      throw ServerException('Unexpected error loading households: $e');
    }
  }
}
