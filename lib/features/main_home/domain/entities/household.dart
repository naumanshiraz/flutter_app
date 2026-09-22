import 'package:equatable/equatable.dart';

class Household extends Equatable {
  final String id;
  final String suite;
  final int floor;
  final String unitType;
  final bool claimed;
  final String buildingId;
  final String buildingName;
  final String? imageUrl;

  const Household({
    required this.id,
    required this.suite,
    required this.floor,
    required this.unitType,
    required this.claimed,
    required this.buildingId,
    required this.buildingName,
    this.imageUrl,
  });

  String get displayName => buildingName;

  String get displaySubtitle => 'Suite $suite • Floor $floor • $unitType';

  @override
  List<Object?> get props => [id, suite, floor, unitType, claimed, buildingId, buildingName, imageUrl];
}
