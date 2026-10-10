import 'package:equatable/equatable.dart';

class Invitation extends Equatable {
  final String id;
  final String householdId;
  final String identifier;
  final String relation;
  final bool canUseDevices;
  final String status;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  const Invitation({
    required this.id,
    required this.householdId,
    required this.identifier,
    required this.relation,
    this.canUseDevices = false,
    required this.status,
    this.expiresAt,
    this.createdAt,
  });

  bool get isEmail => identifier.contains('@');

  @override
  List<Object?> get props =>
      [id, householdId, identifier, relation, canUseDevices, status, expiresAt, createdAt];
}
