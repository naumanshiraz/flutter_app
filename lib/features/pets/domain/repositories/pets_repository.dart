import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';

abstract class PetsRepository {
  Future<Result<List<Pet>>> getPets(String householdId);
  Future<Result<void>> addPet(String householdId, Pet pet);
  Future<Result<void>> updatePet(String householdId, Pet pet);
  Future<Result<void>> deletePet(String householdId, String petId);
}
