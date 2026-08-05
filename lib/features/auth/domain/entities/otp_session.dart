import 'package:equatable/equatable.dart';

enum OtpPurpose { login, signup, adminAccountModification, accountTermination }

enum IdentifierType { email, phone }

class OtpSession extends Equatable {
  final String identifier;
  final IdentifierType identifierType;
  final OtpPurpose purpose;
  final String code;
  final DateTime expiresAt;

  const OtpSession({
    required this.identifier,
    required this.identifierType,
    required this.purpose,
    required this.code,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  @override
  List<Object?> get props => [identifier, identifierType, purpose, code, expiresAt];
}
