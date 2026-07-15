import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';

part 'otp_session_model.freezed.dart';
part 'otp_session_model.g.dart';

/// Data-layer shape of an OTP challenge. Mirrors what a real
/// `POST /auth/request-otp` response will look like once a backend
/// exists — note `code` would never actually be returned by a real API
/// (it'd only be sent via SMS/email); it's included here purely so the
/// mocked `AuthRemoteDataSource` can round-trip it for local
/// verification until then. Remove it from the JSON contract the day a
/// real backend ships.
@freezed
class OtpSessionModel with _$OtpSessionModel {
  const OtpSessionModel._();

  const factory OtpSessionModel({
    required String identifier,
    required String identifierType, // 'email' | 'phone'
    required String purpose, // 'login' | 'signup'
    required String code,
    required DateTime expiresAt,
  }) = _OtpSessionModel;

  factory OtpSessionModel.fromJson(Map<String, dynamic> json) =>
      _$OtpSessionModelFromJson(json);

  OtpSession toEntity() => OtpSession(
        identifier: identifier,
        identifierType:
            identifierType == 'email' ? IdentifierType.email : IdentifierType.phone,
        purpose: purpose == 'signup' ? OtpPurpose.signup : OtpPurpose.login,
        code: code,
        expiresAt: expiresAt,
      );

  factory OtpSessionModel.fromEntity(OtpSession entity) => OtpSessionModel(
        identifier: entity.identifier,
        identifierType: entity.identifierType == IdentifierType.email ? 'email' : 'phone',
        purpose: entity.purpose == OtpPurpose.signup ? 'signup' : 'login',
        code: entity.code,
        expiresAt: entity.expiresAt,
      );
}
