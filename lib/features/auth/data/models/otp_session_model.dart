import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';

part 'otp_session_model.freezed.dart';
part 'otp_session_model.g.dart';

@freezed
class OtpSessionModel with _$OtpSessionModel {
  const OtpSessionModel._();

  const factory OtpSessionModel({
    required String identifier,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _OtpSessionModel;

  factory OtpSessionModel.fromJson(Map<String, dynamic> json) =>
      _$OtpSessionModelFromJson(json);

  OtpSession toEntity({
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  }) =>
      OtpSession(
        identifier: identifier,
        identifierType: identifierType,
        purpose: purpose,
        expiresAt: expiresAt,
      );
}
