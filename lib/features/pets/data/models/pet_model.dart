import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';

part 'pet_model.freezed.dart';
part 'pet_model.g.dart';

@freezed
class PetModel with _$PetModel {
  const PetModel._();

  const factory PetModel({
    required String id,
    String? species,
    @Default('') String breed,
    @Default('') String numberOfPets,
  }) = _PetModel;

  factory PetModel.fromJson(Map<String, dynamic> json) => _$PetModelFromJson(json);

  factory PetModel.fromEntity(Pet entity) => PetModel(
        id: entity.id,
        species: entity.species,
        breed: entity.breed,
        numberOfPets: entity.numberOfPets,
      );

  Pet toEntity() => Pet(
        id: id,
        species: species,
        breed: breed,
        numberOfPets: numberOfPets,
      );
}
