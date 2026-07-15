import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';

/// Domain contract for the Login / OTP / Sign-up-onboarding flow.
/// Presentation depends only on this interface — `AuthFlowRepositoryImpl`
/// (mocked today, real API tomorrow) is an implementation detail.
abstract class AuthFlowRepository {
  /// Requests (or re-sends) a 6-digit OTP for [identifier]. Today this
  /// generates a random code locally; once a backend exists this calls
  /// `POST /auth/request-otp` instead — call sites never change.
  Future<Result<OtpSession>> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  });

  /// Verifies [code] against the currently pending session for
  /// [identifier]. Returns success (true) or a [Failure] describing why
  /// verification failed (expired, mismatched, no pending session).
  Future<Result<bool>> verifyOtp({
    required String identifier,
    required String code,
  });

  /// Persists the final onboarding profile and marks the local session
  /// as authenticated + onboarded.
  Future<Result<void>> completeSignup(UserProfile profile);

  /// Marks the local session authenticated for a returning user (no
  /// profile to collect — they already have one).
  Future<Result<void>> completeLogin(String identifier);
}
