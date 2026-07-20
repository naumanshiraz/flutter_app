import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';

abstract class PetsRepository {
  Future<Result<List<Pet>>> getPets();
  Future<Result<void>> addPet(Pet pet);
  Future<Result<void>> updatePet(Pet pet);
  Future<Result<void>> deletePet(String id);
}
