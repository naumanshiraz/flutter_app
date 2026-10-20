import 'package:equatable/equatable.dart';

class JoinRequest extends Equatable {
  final String id;
  final String requesterName;
  final String identifier;
  final String relation;
  final String status;
  final String developmentName;
  final String buildingName;
  final String suite;
  final String floor;
  final String unitType;

  const JoinRequest({
    required this.id,
    required this.requesterName,
    required this.identifier,
    required this.relation,
    required this.status,
    required this.developmentName,
    required this.buildingName,
    required this.suite,
    required this.floor,
    required this.unitType,
  });

  bool get isEmail => identifier.contains('@');

  @override
  List<Object?> get props =>
      [id, requesterName, identifier, relation, status, developmentName, buildingName, suite, floor, unitType];
}
