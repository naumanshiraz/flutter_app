import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/vehicles/data/datasources/vehicles_local_datasource.dart';
import 'package:pms_app/features/vehicles/data/datasources/vehicles_remote_datasource.dart';
import 'package:pms_app/features/vehicles/data/repositories/vehicles_repository_impl.dart';
import 'package:pms_app/features/vehicles/domain/repositories/vehicles_repository.dart';
import 'package:pms_app/features/vehicles/domain/usecases/vehicles_usecases.dart';

final vehiclesLocalDataSourceProvider = Provider<VehiclesLocalDataSource>((ref) {
  return VehiclesLocalDataSourceImpl(localStorage: ref.watch(localStorageServiceProvider));
});

final vehiclesRemoteDataSourceProvider = Provider<VehiclesRemoteDataSource>((ref) {
  return VehiclesRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final vehiclesRepositoryProvider = Provider<VehiclesRepository>((ref) {
  return VehiclesRepositoryImpl(
    localDataSource: ref.watch(vehiclesLocalDataSourceProvider),
    remoteDataSource: ref.watch(vehiclesRemoteDataSourceProvider),
  );
});

final getVehiclesUseCaseProvider = Provider<GetVehiclesUseCase>((ref) {
  return GetVehiclesUseCase(ref.watch(vehiclesRepositoryProvider));
});

final addVehicleUseCaseProvider = Provider<AddVehicleUseCase>((ref) {
  return AddVehicleUseCase(ref.watch(vehiclesRepositoryProvider));
});

final updateVehicleUseCaseProvider = Provider<UpdateVehicleUseCase>((ref) {
  return UpdateVehicleUseCase(ref.watch(vehiclesRepositoryProvider));
});

final deleteVehicleUseCaseProvider = Provider<DeleteVehicleUseCase>((ref) {
  return DeleteVehicleUseCase(ref.watch(vehiclesRepositoryProvider));
});
