import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/main_home/data/models/control_model.dart';

abstract class MainHomeRemoteDataSource {
  Future<List<ControlModel>> getControls({String? householdId});
  Future<void> toggleControl(String id, bool newState);
}

class MainHomeRemoteDataSourceImpl implements MainHomeRemoteDataSource {
  final Dio _dio;

  MainHomeRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _defaultControls = [
    {
      'id': 'main_entrance',
      'title': 'Main entrance door',
      'subtitle': 'Closed',
      'iconName': 'door',
      'isOn': false,
    },
    {
      'id': 'north_gate',
      'title': 'North campus gate',
      'subtitle': 'Closed',
      'iconName': 'gate',
      'isOn': false,
    },
    {
      'id': 'barrier',
      'title': 'South-East entrance barrier',
      'subtitle': 'Closed',
      'iconName': 'barrier',
      'isOn': false,
    },
    {
      'id': 'elevator',
      'title': 'Bring the lift to my floor',
      'subtitle': 'Ready',
      'iconName': 'elevator',
      'isOn': false,
    },
  ];

  static const Map<String, List<Map<String, dynamic>>> _householdControls = {
    'fa5f0c43-430b-49ab-a84d-6d4e72b956c7': _defaultControls,
    'b6f2a9a0-11d2-4d2a-9a2a-2f0a5b7f0c11': [
      {'id': 'main_entrance', 'title': 'Main entrance door', 'subtitle': 'Open', 'iconName': 'door', 'isOn': true},
      {'id': 'north_gate', 'title': 'North campus gate', 'subtitle': 'Closed', 'iconName': 'gate', 'isOn': false},
      {'id': 'barrier', 'title': 'South-East entrance barrier', 'subtitle': 'Open', 'iconName': 'barrier', 'isOn': true},
      {'id': 'elevator', 'title': 'Bring the lift to my floor', 'subtitle': 'Busy', 'iconName': 'elevator', 'isOn': false},
    ],
    '2c1e6a7a-3b3b-4a2e-8b9a-9e7f6a2d5c33': [
      {'id': 'main_entrance', 'title': 'Main entrance door', 'subtitle': 'Closed', 'iconName': 'door', 'isOn': false},
      {'id': 'north_gate', 'title': 'North campus gate', 'subtitle': 'Open', 'iconName': 'gate', 'isOn': true},
      {'id': 'barrier', 'title': 'South-East entrance barrier', 'subtitle': 'Closed', 'iconName': 'barrier', 'isOn': false},
      {'id': 'elevator', 'title': 'Bring the lift to my floor', 'subtitle': 'Ready', 'iconName': 'elevator', 'isOn': false},
    ],
  };

  @override
  Future<List<ControlModel>> getControls({String? householdId}) async {
    try {
      // MOCK:
      await Future.delayed(const Duration(milliseconds: 500));
      final rows = (householdId != null ? _householdControls[householdId] : null) ?? _defaultControls;
      return rows.map(ControlModel.fromJson).toList();

      // REAL API (uncomment and provide endpoint when available)
      // final response = await _dio.get(
      //   AppConstants.endpointControls,
      //   queryParameters: {if (householdId != null) 'household_id': householdId},
      // );
      // final data = response.data as List<dynamic>;
      // return data.map((j) => ControlModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch controls from server.');
    } catch (e) {
      throw ServerException('Unexpected error fetching controls: $e');
    }
  }

  @override
  Future<void> toggleControl(String id, bool newState) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      // REAL API call example:
      // await _dio.post('/controls/$id/toggle', data: {'state': newState});
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to toggle control on server.');
    } catch (e) {
      throw ServerException('Unexpected error toggling control: $e');
    }
  }
}
