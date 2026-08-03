import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String? type;
  final String? brand;
  final String? engineType;
  final String licensePlate;

  const Vehicle({
    required this.id,
    this.type,
    this.brand,
    this.engineType,
    this.licensePlate = '',
  });

  bool get isValid =>
      type != null && brand != null && engineType != null && licensePlate.trim().isNotEmpty;

  Vehicle copyWith({
    String? type,
    String? brand,
    String? engineType,
    String? licensePlate,
  }) {
    return Vehicle(
      id: id,
      type: type ?? this.type,
      brand: brand ?? this.brand,
      engineType: engineType ?? this.engineType,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  @override
  List<Object?> get props => [id, type, brand, engineType, licensePlate];
}
