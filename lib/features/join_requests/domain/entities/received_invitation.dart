import 'package:equatable/equatable.dart';

class ReceivedInvitation extends Equatable {
  final String id;
  final String inviterName;
  final String relation;
  final String status;
  final String household;
  final DateTime? expiresAt;

  const ReceivedInvitation({
    required this.id,
    required this.inviterName,
    required this.relation,
    required this.status,
    required this.household,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [id, inviterName, relation, status, household, expiresAt];
}
