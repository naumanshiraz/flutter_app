import 'package:equatable/equatable.dart';

class JoinRequest extends Equatable {
  final String id;
  final String requesterName;
  final String identifier;
  final String relation;
  final String status;
  final String household;

  const JoinRequest({
    required this.id,
    required this.requesterName,
    required this.identifier,
    required this.relation,
    required this.status,
    required this.household,
  });

  @override
  List<Object?> get props => [id, requesterName, identifier, relation, status, household];
}
