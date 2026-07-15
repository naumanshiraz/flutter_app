import 'package:equatable/equatable.dart';

/// Domain entity representing the current authentication session.
/// Pure Dart — no JSON, no Hive, no Dio. Presentation/Domain only ever
/// see this shape.
class AuthSession extends Equatable {
  final bool isAuthenticated;
  final String? userId;
  final bool onboardingComplete;

  const AuthSession({
    required this.isAuthenticated,
    this.userId,
    this.onboardingComplete = false,
  });

  factory AuthSession.guest() => const AuthSession(isAuthenticated: false);

  @override
  List<Object?> get props => [isAuthenticated, userId, onboardingComplete];
}
