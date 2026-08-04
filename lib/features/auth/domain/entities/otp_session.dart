import 'package:equatable/equatable.dart';

/// Distinguishes an OTP requested to sign an *existing* user in from one
/// requested to verify a *new* user during sign-up — the verification
/// screen is shared, but what happens after Confirm differs.
enum OtpPurpose { login, signup, adminAccountModification }

enum IdentifierType { email, phone }

/// Domain entity describing a live (unexpired) OTP challenge. The actual
/// numeric code is generated client-side today (no backend); see
/// `OtpRemoteDataSource` for exactly where that will be replaced by a
/// real `/auth/request-otp` call.
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
