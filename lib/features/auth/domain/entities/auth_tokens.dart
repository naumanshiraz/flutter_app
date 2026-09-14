import 'package:equatable/equatable.dart';

/// Result of a successful `otp/verify` or `refresh` call.
///
/// `token` is a JWT valid 24 hours. `refreshToken` is single-use — presenting
/// an already-used one revokes every session for the user, so it must be
/// persisted (never re-sent) as soon as it is received.
class AuthTokens extends Equatable {
  final String token;
  final String refreshToken;
  final bool onboardingComplete;

  const AuthTokens({
    required this.token,
    required this.refreshToken,
    this.onboardingComplete = false,
  });

  @override
  List<Object?> get props => [token, refreshToken, onboardingComplete];
}
