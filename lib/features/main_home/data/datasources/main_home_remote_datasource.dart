import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/main_home/data/models/control_model.dart';

/// Remote datasource interface. Currently mocked (no backend).
abstract class MainHomeRemoteDataSource {
  Future<List<ControlModel>> getControls({String? propertyId});
  Future<void> toggleControl(String id, bool newState);
}

class MainHomeRemoteDataSourceImpl implements MainHomeRemoteDataSource {
  final Dio _dio;

  MainHomeRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockControls = [
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

  @override
  Future<List<ControlModel>> getControls({String? propertyId}) async {
    try {
      // MOCK:
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockControls.map(ControlModel.fromJson).toList();

      // REAL API (uncomment and provide endpoint when available)
      // final response = await _dio.get(AppConstants.endpointControls);
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