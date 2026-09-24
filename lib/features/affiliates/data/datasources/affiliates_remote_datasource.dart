import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/affiliates/data/models/affiliate_model.dart';

abstract class AffiliatesRemoteDataSource {
  Future<List<AffiliateModel>> getAffiliates({String? householdId});
  Future<void> addOrUpdateAffiliate(AffiliateModel affiliate);
  Future<void> deleteAffiliate(String id);
}

class AffiliatesRemoteDataSourceImpl implements AffiliatesRemoteDataSource {
  final Dio _dio;
  AffiliatesRemoteDataSourceImpl(this._dio);

  static const String _unassignedKey = 'unassigned';

  static final Map<String, List<Map<String, dynamic>>> _mockDb = {
    'fa5f0c43-430b-49ab-a84d-6d4e72b956c7': [
      {
        'id': 'aff-1',
        'household_id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'name': 'Gerel Jargal',
        'email': 'gerel@gmail.com',
        'phone': '+976 99885566',
        'relationship': 'Mother',
        'status': 'Active',
      },
      {
        'id': 'aff-2',
        'household_id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'name': 'Dulamjav Jargal',
        'email': 'dulamjav@gmail.com',
        'phone': '+976 99556622',
        'relationship': 'Husband',
        'status': 'Active',
      },
      {
        'id': 'aff-3',
        'household_id': 'fa5f0c43-430b-49ab-a84d-6d4e72b956c7',
        'name': 'Nyam Dorj',
        'email': 'nyam@gmail.com',
        'phone': '+976 88225566',
        'relationship': 'Tenant',
        'status': 'Active',
      },
    ],
    _unassignedKey: [],
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
}
