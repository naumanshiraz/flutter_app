import 'package:equatable/equatable.dart';

class AvailableSuite extends Equatable {
  final String id;
  final String suite;
  final String floor;
  final String unitType;
  final String buildingId;
  final String buildingName;

  const AvailableSuite({
    required this.id,
    required this.suite,
    required this.floor,
    required this.unitType,
    required this.buildingId,
    required this.buildingName,
  });

  @override
  List<Object?> get props => [id, suite, floor, unitType, buildingId, buildingName];
}
