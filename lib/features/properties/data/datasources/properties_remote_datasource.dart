import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/properties/data/models/available_suite_model.dart';
import 'package:pms_app/features/properties/data/models/property_model.dart';

abstract class PropertiesRemoteDataSource {
  Future<List<AvailableSuiteModel>> getAvailableSuites(String campusId);
  Future<void> submitClaimRequest(String householdId);
  Future<void> updateProperty(PropertyModel property);
  Future<void> deleteProperty(String id);
}

class PropertiesRemoteDataSourceImpl implements PropertiesRemoteDataSource {
  final Dio _dio;

  PropertiesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<AvailableSuiteModel>> getAvailableSuites(String campusId) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointCampusHouseholds(campusId),
        queryParameters: {'q': '', 'claimed': false},
      );
      final rows = response.data as List<dynamic>;
      return rows.map((row) => AvailableSuiteModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to load suites.'));
    } catch (e) {
      throw ServerException('Unexpected error loading suites: $e');
    }
  }

  @override
  Future<void> submitClaimRequest(String householdId) async {
    try {
      await _dio.post(
        AppConstants.endpointResidencyRequests,
        data: {'household_id': householdId, 'kind': 'claim'},
      );
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to submit request.'));
    } catch (e) {
      throw ServerException('Unexpected error submitting request: $e');
    }
  }

  @override
  Future<void> updateProperty(PropertyModel property) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.patch('/user/properties/${property.id}', data: property.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update property.');
    } catch (e) {
      throw ServerException('Unexpected error updating property: $e');
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // await _dio.delete('/user/properties/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete property.');
    } catch (e) {
      throw ServerException('Unexpected error deleting property: $e');
    }
  }

  String _message(DioException e, String fallback) {
    final data = e.response?.data;
    final serverMessage = data is Map ? data['message']?.toString() : null;
    return serverMessage ?? e.message ?? fallback;
  }
}
