import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';

abstract class VehiclesRepository {
  Future<Result<List<Vehicle>>> getVehicles();
  Future<Result<void>> addVehicle(Vehicle vehicle);
  Future<Result<void>> updateVehicle(Vehicle vehicle);
  Future<Result<void>> deleteVehicle(String id);
}
