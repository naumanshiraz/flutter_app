import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/pets/data/datasources/pets_local_datasource.dart';
import 'package:pms_app/features/pets/data/datasources/pets_remote_datasource.dart';
import 'package:pms_app/features/pets/data/models/pet_model.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/domain/repositories/pets_repository.dart';

class PetsRepositoryImpl implements PetsRepository {
  final PetsLocalDataSource _localDataSource;
  final PetsRemoteDataSource _remoteDataSource;

  PetsRepositoryImpl({
    required PetsLocalDataSource localDataSource,
    required PetsRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<Pet>>> getPets() async {
    try {
      final models = _localDataSource.getPets();
      return Success(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load pets: $e'));
    }
  }

  @override
  Future<Result<void>> addPet(Pet pet) async {
    try {
      final model = PetModel.fromEntity(pet);
      await _remoteDataSource.addPet(model);
      final current = _localDataSource.getPets();
      await _localDataSource.savePets([...current, model]);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to add pet: $e'));
    }
  }

  @override
  Future<Result<void>> updatePet(Pet pet) async {
    try {
      final model = PetModel.fromEntity(pet);
      await _remoteDataSource.updatePet(model);
      final current = _localDataSource.getPets();
      await _localDataSource.savePets(current.map((p) => p.id == model.id ? model : p).toList());
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update pet: $e'));
    }
  }

  @override
  Future<Result<void>> deletePet(String id) async {
    try {
      await _remoteDataSource.deletePet(id);
      final current = _localDataSource.getPets();
      await _localDataSource.savePets(current.where((p) => p.id != id).toList());
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete pet: $e'));
    }
  }
}
