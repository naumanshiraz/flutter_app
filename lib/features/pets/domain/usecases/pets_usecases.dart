import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/domain/repositories/pets_repository.dart';

class GetPetsUseCase {
  final PetsRepository _repository;
  const GetPetsUseCase(this._repository);
  Future<Result<List<Pet>>> call() => _repository.getPets();
}

class AddPetUseCase {
  final PetsRepository _repository;
  const AddPetUseCase(this._repository);
  Future<Result<void>> call(Pet pet) => _repository.addPet(pet);
}

class UpdatePetUseCase {
  final PetsRepository _repository;
  const UpdatePetUseCase(this._repository);
  Future<Result<void>> call(Pet pet) => _repository.updatePet(pet);
}

class DeletePetUseCase {
  final PetsRepository _repository;
  const DeletePetUseCase(this._repository);
  Future<Result<void>> call(String id) => _repository.deletePet(id);
}
