import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';

part 'auth_session_model.freezed.dart';
part 'auth_session_model.g.dart';

/// Data-layer model. Knows how to (de)serialize JSON — the Domain layer
/// never sees this class, only the plain [AuthSession] entity it maps to.
/// Run `dart run build_runner build --delete-conflicting-outputs` to
/// generate `auth_session_model.freezed.dart` / `.g.dart`.
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
