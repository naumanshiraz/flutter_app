import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';

part 'pet_model.freezed.dart';
part 'pet_model.g.dart';

String? _label(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}

@freezed
class PetModel with _$PetModel {
  const PetModel._();

  const factory PetModel({
    required String id,
    String? species,
    @Default('') String breed,
    @JsonKey(name: 'number_of_pets') @Default(1) int numberOfPets,
  }) = _PetModel;

  factory PetModel.fromJson(Map<String, dynamic> json) => _$PetModelFromJson(json);

  factory PetModel.fromEntity(Pet entity) => PetModel(
        id: entity.id,
        species: entity.species,
        breed: entity.breed,
        numberOfPets: int.tryParse(entity.numberOfPets.trim()) ?? 1,
      );

  Map<String, dynamic> toRequestJson() => {
        'species': species?.toLowerCase(),
        'breed': breed,
        'number_of_pets': numberOfPets,
      };

  Pet toEntity() => Pet(
        id: id,
        species: _label(species),
        breed: breed,
        numberOfPets: numberOfPets.toString(),
      );
}
