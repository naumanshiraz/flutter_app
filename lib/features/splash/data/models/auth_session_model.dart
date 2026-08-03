import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';

part 'auth_session_model.freezed.dart';
part 'auth_session_model.g.dart';

@freezed
class AuthSessionModel with _$AuthSessionModel {
  const AuthSessionModel._();

  const factory AuthSessionModel({
    required bool isAuthenticated,
    String? userId,
    @Default(false) bool onboardingComplete,
  }) = _AuthSessionModel;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionModelFromJson(json);

  factory AuthSessionModel.fromEntity(AuthSession entity) => AuthSessionModel(
        isAuthenticated: entity.isAuthenticated,
        userId: entity.userId,
        onboardingComplete: entity.onboardingComplete,
      );

  AuthSession toEntity() => AuthSession(
        isAuthenticated: isAuthenticated,
        userId: userId,
        onboardingComplete: onboardingComplete,
      );
}
