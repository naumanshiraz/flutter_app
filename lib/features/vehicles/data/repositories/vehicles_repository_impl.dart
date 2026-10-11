import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/vehicles/data/datasources/vehicles_remote_datasource.dart';
import 'package:pms_app/features/vehicles/data/models/vehicle_model.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/domain/repositories/vehicles_repository.dart';

class VehiclesRepositoryImpl implements VehiclesRepository {
  final VehiclesRemoteDataSource _remoteDataSource;

  VehiclesRepositoryImpl({required VehiclesRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<Result<T>> _guard<T>(Future<T> Function() action, String fallback) async {
    try {
      return Success(await action());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('$fallback: $e'));
    }
  }

  @override
  Future<Result<List<Vehicle>>> getVehicles(String householdId) => _guard(() async {
        final models = await _remoteDataSource.getVehicles(householdId);
        return models.map((m) => m.toEntity()).toList();
      }, 'Failed to load vehicles');

  @override
  Future<Result<void>> addVehicle(String householdId, Vehicle vehicle) => _guard(
        () => _remoteDataSource.addVehicle(householdId, VehicleModel.fromEntity(vehicle)),
        'Failed to add vehicle',
      );

  @override
  Future<Result<void>> updateVehicle(String householdId, Vehicle vehicle) => _guard(
        () => _remoteDataSource.updateVehicle(householdId, VehicleModel.fromEntity(vehicle)),
        'Failed to update vehicle',
      );

  @override
  Future<Result<void>> deleteVehicle(String householdId, String vehicleId) => _guard(
        () => _remoteDataSource.deleteVehicle(householdId, vehicleId),
        'Failed to delete vehicle',
      );
}
