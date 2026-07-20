import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/vehicles/data/models/vehicle_model.dart';

/// **There is no backend yet.** Every method simulates a network
/// round-trip; the real REST calls are written and commented directly
/// below each — flip them once a backend exists.
abstract class VehiclesRemoteDataSource {
  Future<void> addVehicle(VehicleModel vehicle);
  Future<void> updateVehicle(VehicleModel vehicle);
  Future<void> deleteVehicle(String id);
}

class VehiclesRemoteDataSourceImpl implements VehiclesRemoteDataSource {
  final Dio _dio;

  VehiclesRemoteDataSourceImpl(this._dio);

  @override
  Future<void> addVehicle(VehicleModel vehicle) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.post('/user/vehicles', data: vehicle.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to add vehicle.');
    } catch (e) {
      throw ServerException('Unexpected error adding vehicle: $e');
    }
  }

  @override
  Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.patch('/user/vehicles/${vehicle.id}', data: vehicle.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update vehicle.');
    } catch (e) {
      throw ServerException('Unexpected error updating vehicle: $e');
    }
  }

  @override
  Future<void> deleteVehicle(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // await _dio.delete('/user/vehicles/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete vehicle.');
    } catch (e) {
      throw ServerException('Unexpected error deleting vehicle: $e');
    }
  }
}
