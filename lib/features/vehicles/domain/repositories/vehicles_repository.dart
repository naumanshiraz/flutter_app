import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';

abstract class VehiclesRepository {
  Future<Result<List<Vehicle>>> getVehicles(String householdId);
  Future<Result<void>> addVehicle(String householdId, Vehicle vehicle);
  Future<Result<void>> updateVehicle(String householdId, Vehicle vehicle);
  Future<Result<void>> deleteVehicle(String householdId, String vehicleId);
}
