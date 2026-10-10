import 'package:equatable/equatable.dart';

class ResidencyRequest extends Equatable {
  final String id;
  final String householdId;
  final String kind;
  final String status;
  final String suite;
  final String floor;
  final String unitType;
  final String buildingName;
  final String developmentName;

  const ResidencyRequest({
    required this.id,
    required this.householdId,
    required this.kind,
    required this.status,
    required this.suite,
    required this.floor,
    required this.unitType,
    required this.buildingName,
    required this.developmentName,
  });

  bool get isPending => status.toLowerCase() == 'pending';

  @override
  List<Object?> get props =>
      [id, householdId, kind, status, suite, floor, unitType, buildingName, developmentName];
}
