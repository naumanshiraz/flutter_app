import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/domain/repositories/vehicles_repository.dart';

class GetVehiclesUseCase {
  final VehiclesRepository _repository;
  const GetVehiclesUseCase(this._repository);

  Future<Result<List<Vehicle>>> call() => _repository.getVehicles();
}

class AddVehicleUseCase {
  final VehiclesRepository _repository;
  const AddVehicleUseCase(this._repository);

  Future<Result<void>> call(Vehicle vehicle) => _repository.addVehicle(vehicle);
}

class UpdateVehicleUseCase {
  final VehiclesRepository _repository;
  const UpdateVehicleUseCase(this._repository);

  Future<Result<void>> call(Vehicle vehicle) => _repository.updateVehicle(vehicle);
}

class DeleteVehicleUseCase {
  final VehiclesRepository _repository;
  const DeleteVehicleUseCase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteVehicle(id);
}
