import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/affiliates/data/models/affiliate_model.dart';
import 'package:pms_app/features/main_home/data/models/household_model.dart';

abstract class AffiliatesRemoteDataSource {
  Future<List<AffiliateModel>> getAffiliates({String? householdId});
  Future<void> addOrUpdateAffiliate(AffiliateModel affiliate);
  Future<void> deleteAffiliate(String id);
  Future<List<HouseholdModel>> getAssignedHouseholds(String affiliateId);
  Future<void> removeHouseholdAccess({required String affiliateId, required String householdId});
}

class AffiliatesRemoteDataSourceImpl implements AffiliatesRemoteDataSource {
  final Dio _dio;
  AffiliatesRemoteDataSourceImpl(this._dio);

  static const String _unassignedKey = 'unassigned';

  // GET /user/affiliates/{id}/households. Unknown ids resolve to an empty list.
  static final Map<String, List<Map<String, dynamic>>> _mockAssignedHouseholds = {
    'aff-1': [
      {
        'id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'suite': '100',
        'floor': 1,
        'unit_type': 'Residential',
        'claimed': false,
        'building_id': 'a8e50f37-81cf-4174-95ed-53c994ffa521',
        'building_name': '215B Block',
      },
      {
        'id': 'b6f2a9a0-11d2-4d2a-9a2a-2f0a5b7f0c11',
        'suite': '201',
        'floor': 2,
        'unit_type': 'Residential',
        'claimed': true,
        'building_id': 'a8e50f37-81cf-4174-95ed-53c994ffa521',
        'building_name': '215B Block',
      },
    ],
    'aff-2': [
      {
        'id': '2c1e6a7a-3b3b-4a2e-8b9a-9e7f6a2d5c33',
        'suite': '305',
        'floor': 3,
        'unit_type': 'Commercial',
        'claimed': false,
        'building_id': 'e2b4c9d1-6a55-4a0e-9d4f-3c2b1a908f77',
        'building_name': '212A Tower',
      },
    ],
  };

  static final Map<String, List<Map<String, dynamic>>> _mockDb = {
    'fa5f0c43-430b-49ab-a84d-6d4e72b956c7': [
      {
        'id': 'aff-1',
        'household_id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'name': 'Gerel Jargal',
        'email': 'gerel@gmail.com',
        'phone': '+976 99885566',
        'relationship': 'Mother',
        'status': 'Engaged',
        'added_by_name': 'Narandelger Jargal',
      },
      {
        'id': 'aff-2',
        'household_id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'name': 'Dulamjav Jargal',
        'email': 'dulamjav@gmail.com',
        'phone': '+976 99556622',
        'relationship': 'Husband',
        'status': 'Engaged',
        'added_by_name': 'Narandelger Jargal',
      },
      {
        'id': 'aff-3',
        'household_id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'name': 'Nyam Dorj',
        'email': 'nyam@gmail.com',
        'phone': '+976 88225566',
        'relationship': 'Tenant',
        'status': 'Engaged',
        'added_by_name': 'Narandelger Jargal',
      },
    ],
    _unassignedKey: [
      {
        'id': 'aff-4',
        'household_id': null,
        'name': 'Dulamjav Jargal',
        'email': 'dulamjav@gmail.com',
        'phone': '99858623',
        'relationship': 'Mother',
        'status': 'Pending',
        'added_by_name': 'Narandelger Jargal',
      },
    ],
  };

  @override
  Future<List<AffiliateModel>> getAffiliates({String? householdId}) async {
    try {
      // ---- MOCK (no backend yet) ------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));
      final rows = householdId == null
          ? _mockDb.values.expand((v) => v).toList()
          : (_mockDb[householdId] ?? const []);
      return rows.map(AffiliateModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend is live) -------------
      // final response = await _dio.get(
      //   '/user/affiliates',
      //   queryParameters: {if (householdId != null) 'household_id': householdId},
      // );
      // final data = response.data as List<dynamic>;
      // return data.map((j) => AffiliateModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load affiliates.');
    } catch (e) {
      throw ServerException('Unexpected error loading affiliates: $e');
    }
  }

  @override
  Future<void> addOrUpdateAffiliate(AffiliateModel affiliate) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final key = affiliate.householdId ?? _unassignedKey;
      final list = _mockDb.putIfAbsent(key, () => []);
      final idx = list.indexWhere((m) => (m['id'] as String) == affiliate.id);
      final json = {
        'id': affiliate.id,
        'household_id': affiliate.householdId,
        'name': affiliate.name,
        'email': affiliate.email,
        'phone': affiliate.phone,
        'relationship': affiliate.relationship,
        'status': affiliate.status,
        'added_by_name': affiliate.addedByName,
      };
      if (idx >= 0) {
        list[idx] = json;
      } else {
        list.add(json);
      }

      // ---- REAL API (uncomment once the backend is live) -------------
      // if (isNew) {
      //   await _dio.post('/user/affiliates', data: affiliate.toJson());
      // } else {
      //   await _dio.patch('/user/affiliates/${affiliate.id}', data: affiliate.toJson());
      // }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to save affiliate.');
    } catch (e) {
      throw ServerException('Unexpected error saving affiliate: $e');
    }
  }

  @override
  Future<void> deleteAffiliate(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      for (final list in _mockDb.values) {
        list.removeWhere((m) => (m['id'] as String) == id);
      }
      // await _dio.delete('/user/affiliates/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete affiliate.');
    } catch (e) {
      throw ServerException('Unexpected error deleting affiliate: $e');
    }
  }

  @override
  Future<List<HouseholdModel>> getAssignedHouseholds(String affiliateId) async {
    try {
      // ---- MOCK (no backend yet) ------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));
      final rows = _mockAssignedHouseholds[affiliateId] ?? const [];
      return rows.map(HouseholdModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend is live) -------------
      // final response = await _dio.get('/user/affiliates/$affiliateId/households');
      // final data = response.data as List<dynamic>;
      // return data.map((j) => HouseholdModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load assigned properties.');
    } catch (e) {
      throw ServerException('Unexpected error loading assigned properties: $e');
    }
  }

  @override
  Future<void> removeHouseholdAccess({required String affiliateId, required String householdId}) async {
    try {
      // ---- MOCK (no backend yet) ------------------------------------
      await Future.delayed(const Duration(milliseconds: 400));
      _mockAssignedHouseholds[affiliateId]?.removeWhere((m) => (m['id'] as String) == householdId);

      // ---- REAL API (uncomment once the backend is live) -------------
      // await _dio.delete('/user/affiliates/$affiliateId/households/$householdId');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to remove access.');
    } catch (e) {
      throw ServerException('Unexpected error removing access: $e');
    }
  }
}
