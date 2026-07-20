import 'package:equatable/equatable.dart';

/// A single pet — Species, Breed, Number of pets,
/// as shown on "Do you have any pets?".
class Pet extends Equatable {
  final String id;
  final String? species;
  final String breed;
  final String numberOfPets;

  const Pet({
    required this.id,
    this.species,
    this.breed = '',
    this.numberOfPets = '',
  });

  bool get isValid =>
      species != null &&
      breed.trim().isNotEmpty &&
      numberOfPets.trim().isNotEmpty &&
      int.tryParse(numberOfPets.trim()) != null &&
      int.parse(numberOfPets.trim()) > 0;

  Pet copyWith({
    String? species,
    String? breed,
    String? numberOfPets,
  }) {
    return Pet(
      id: id,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      numberOfPets: numberOfPets ?? this.numberOfPets,
    );
  }

  @override
  List<Object?> get props => [id, species, breed, numberOfPets];
}
