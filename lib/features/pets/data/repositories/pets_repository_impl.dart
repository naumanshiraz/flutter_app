import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/pets/data/datasources/pets_remote_datasource.dart';
import 'package:pms_app/features/pets/data/models/pet_model.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/domain/repositories/pets_repository.dart';

class PetsRepositoryImpl implements PetsRepository {
  final PetsRemoteDataSource _remoteDataSource;

  PetsRepositoryImpl({required PetsRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

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
  Future<Result<List<Pet>>> getPets(String householdId) => _guard(() async {
        final models = await _remoteDataSource.getPets(householdId);
        return models.map((m) => m.toEntity()).toList();
      }, 'Failed to load pets');

  @override
  Future<Result<void>> addPet(String householdId, Pet pet) =>
      _guard(() => _remoteDataSource.addPet(householdId, PetModel.fromEntity(pet)), 'Failed to add pet');

  @override
  Future<Result<void>> updatePet(String householdId, Pet pet) =>
      _guard(() => _remoteDataSource.updatePet(householdId, PetModel.fromEntity(pet)), 'Failed to update pet');

  @override
  Future<Result<void>> deletePet(String householdId, String petId) =>
      _guard(() => _remoteDataSource.deletePet(householdId, petId), 'Failed to delete pet');
}
