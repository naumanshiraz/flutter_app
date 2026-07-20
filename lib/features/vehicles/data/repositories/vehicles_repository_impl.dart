import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/vehicles/data/datasources/vehicles_local_datasource.dart';
import 'package:pms_app/features/vehicles/data/datasources/vehicles_remote_datasource.dart';
import 'package:pms_app/features/vehicles/data/models/vehicle_model.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/domain/repositories/vehicles_repository.dart';

class VehiclesRepositoryImpl implements VehiclesRepository {
  final VehiclesLocalDataSource _localDataSource;
  final VehiclesRemoteDataSource _remoteDataSource;

  VehiclesRepositoryImpl({
    required VehiclesLocalDataSource localDataSource,
    required VehiclesRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<Vehicle>>> getVehicles() async {
    try {
      final models = _localDataSource.getVehicles();
      return Success(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load vehicles: $e'));
    }
  }

  @override
  Future<Result<void>> addVehicle(Vehicle vehicle) async {
    try {
      final model = VehicleModel.fromEntity(vehicle);
      await _remoteDataSource.addVehicle(model);

      final current = _localDataSource.getVehicles();
      await _localDataSource.saveVehicles([...current, model]);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to add vehicle: $e'));
    }
  }

  @override
  Future<Result<void>> updateVehicle(Vehicle vehicle) async {
    try {
      final model = VehicleModel.fromEntity(vehicle);
      await _remoteDataSource.updateVehicle(model);

      final current = _localDataSource.getVehicles();
      final updated = current.map((v) => v.id == model.id ? model : v).toList();
      await _localDataSource.saveVehicles(updated);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update vehicle: $e'));
    }
  }

  @override
  Future<Result<void>> deleteVehicle(String id) async {
    try {
      await _remoteDataSource.deleteVehicle(id);

      final current = _localDataSource.getVehicles();
      final updated = current.where((v) => v.id != id).toList();
      await _localDataSource.saveVehicles(updated);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete vehicle: $e'));
    }
  }
}
