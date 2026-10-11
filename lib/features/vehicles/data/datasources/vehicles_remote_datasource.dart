import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/vehicles/data/models/vehicle_model.dart';

abstract class VehiclesRemoteDataSource {
  Future<List<VehicleModel>> getVehicles(String householdId);
  Future<void> addVehicle(String householdId, VehicleModel vehicle);
  Future<void> updateVehicle(String householdId, VehicleModel vehicle);
  Future<void> deleteVehicle(String householdId, String vehicleId);
}

class VehiclesRemoteDataSourceImpl implements VehiclesRemoteDataSource {
  final Dio _dio;

  VehiclesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<VehicleModel>> getVehicles(String householdId) async {
    try {
      final response = await _dio.get(AppConstants.endpointHouseholdVehicles(householdId));
      final rows = response.data as List<dynamic>;
      return rows.map((row) => VehicleModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to load vehicles.'));
    } catch (e) {
      throw ServerException('Unexpected error loading vehicles: $e');
    }
  }

  @override
  Future<void> addVehicle(String householdId, VehicleModel vehicle) async {
    try {
      await _dio.post(AppConstants.endpointHouseholdVehicles(householdId), data: vehicle.toRequestJson());
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to add vehicle.'));
    } catch (e) {
      throw ServerException('Unexpected error adding vehicle: $e');
    }
  }

  @override
  Future<void> updateVehicle(String householdId, VehicleModel vehicle) async {
    try {
      await _dio.patch(
        AppConstants.endpointHouseholdVehicle(householdId, vehicle.id),
        data: vehicle.toRequestJson(),
      );
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to update vehicle.'));
    } catch (e) {
      throw ServerException('Unexpected error updating vehicle: $e');
    }
  }

  @override
  Future<void> deleteVehicle(String householdId, String vehicleId) async {
    try {
      await _dio.delete(AppConstants.endpointHouseholdVehicle(householdId, vehicleId));
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to delete vehicle.'));
    } catch (e) {
      throw ServerException('Unexpected error deleting vehicle: $e');
    }
  }

  String _message(DioException e, String fallback) {
    final data = e.response?.data;
    final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
    return serverMessage ?? e.message ?? fallback;
  }
}
