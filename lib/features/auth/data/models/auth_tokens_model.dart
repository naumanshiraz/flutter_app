import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/auth/domain/entities/auth_tokens.dart';

part 'auth_tokens_model.freezed.dart';
part 'auth_tokens_model.g.dart';

@freezed
class AuthTokensModel with _$AuthTokensModel {
  const AuthTokensModel._();

  const factory AuthTokensModel({
    required String token,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'onboarding_complete') @Default(false) bool onboardingComplete,
  }) = _AuthTokensModel;

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  AuthTokens toEntity() => AuthTokens(
        token: token,
        refreshToken: refreshToken,
        onboardingComplete: onboardingComplete,
      );
}
