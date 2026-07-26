import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/main_home/data/models/visitor_model.dart';

/// Remote datasource interface for visitor schedules.
/// Currently mocked (no real backend).
abstract class VisitorRemoteDataSource {
  Future<List<VisitorModel>> getSchedules();
  Future<void> addOrUpdateSchedule(VisitorModel model);
  Future<void> deleteSchedule(String id);
}

class VisitorRemoteDataSourceImpl implements VisitorRemoteDataSource {
  final Dio _dio;

  VisitorRemoteDataSourceImpl(this._dio);

  // In-memory mock DB used until backend exists.
  static final List<Map<String, dynamic>> _mockDb = <Map<String, dynamic>>[
    {
      'id': 'v1',
      'guestName': 'Dolgor',
      'licensePlate': '7586 - YBP',
      'time': '17:30',
      'date': '2024-04-20',
    },
  ];

  @override
  Future<List<VisitorModel>> getSchedules() async {
    try {
      // MOCK: simulate network latency
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockDb.map((j) => VisitorModel.fromJson(j)).toList();

      // REAL API example (uncomment when endpoint exists)
      // final resp = await _dio.get(AppConstants.endpointVisitorSchedules);
      // final data = resp.data as List<dynamic>;
      // return data.map((j) => VisitorModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load visitor schedules from server.');
    } catch (e) {
      throw ServerException('Unexpected error loading visitor schedules: $e');
    }
  }

  @override
  Future<void> addOrUpdateSchedule(VisitorModel model) async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      final idx = _mockDb.indexWhere((m) => (m['id'] as String) == model.id);
      if (idx >= 0) {
        _mockDb[idx] = model.toJson();
      } else {
        _mockDb.add(model.toJson());
      }

      // REAL API example:
      // if (isNew) await _dio.post('/visitor-schedules', data: model.toJson());
      // else await _dio.put('/visitor-schedules/${model.id}', data: model.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to save visitor schedule on server.');
    } catch (e) {
      throw ServerException('Unexpected error saving visitor schedule: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      _mockDb.removeWhere((m) => (m['id'] as String) == id);

      // REAL API example:
      // await _dio.delete('/visitor-schedules/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete visitor schedule on server.');
    } catch (e) {
      throw ServerException('Unexpected error deleting visitor schedule: $e');
    }
  }
}