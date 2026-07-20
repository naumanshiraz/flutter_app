import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/pets/data/datasources/pets_local_datasource.dart';
import 'package:pms_app/features/pets/data/datasources/pets_remote_datasource.dart';
import 'package:pms_app/features/pets/data/repositories/pets_repository_impl.dart';
import 'package:pms_app/features/pets/domain/repositories/pets_repository.dart';
import 'package:pms_app/features/pets/domain/usecases/pets_usecases.dart';

final petsLocalDataSourceProvider = Provider<PetsLocalDataSource>((ref) {
  return PetsLocalDataSourceImpl(localStorage: ref.watch(localStorageServiceProvider));
});

final petsRemoteDataSourceProvider = Provider<PetsRemoteDataSource>((ref) {
  return PetsRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final petsRepositoryProvider = Provider<PetsRepository>((ref) {
  return PetsRepositoryImpl(
    localDataSource: ref.watch(petsLocalDataSourceProvider),
    remoteDataSource: ref.watch(petsRemoteDataSourceProvider),
  );
});

final getPetsUseCaseProvider = Provider<GetPetsUseCase>((ref) {
  return GetPetsUseCase(ref.watch(petsRepositoryProvider));
});

final addPetUseCaseProvider = Provider<AddPetUseCase>((ref) {
  return AddPetUseCase(ref.watch(petsRepositoryProvider));
});

final updatePetUseCaseProvider = Provider<UpdatePetUseCase>((ref) {
  return UpdatePetUseCase(ref.watch(petsRepositoryProvider));
});

final deletePetUseCaseProvider = Provider<DeletePetUseCase>((ref) {
  return DeletePetUseCase(ref.watch(petsRepositoryProvider));
});
