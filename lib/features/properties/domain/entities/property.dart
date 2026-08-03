import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String id;
  final String suite;
  final String? floor;
  final String? type;
  final String? building;

  const Property({
    required this.id,
    this.suite = '',
    this.floor,
    this.type,
    this.building,
  });

  bool get isValid =>
      suite.trim().isNotEmpty && floor != null && type != null && building != null;

  Property copyWith({
    String? suite,
    String? floor,
    String? type,
    String? building,
  }) {
    return Property(
      id: id,
      suite: suite ?? this.suite,
      floor: floor ?? this.floor,
      type: type ?? this.type,
      building: building ?? this.building,
    );
  }

  @override
  List<Object?> get props => [id, suite, floor, type, building];
}
