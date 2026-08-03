import 'package:equatable/equatable.dart';

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
