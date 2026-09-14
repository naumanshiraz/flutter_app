import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';

abstract class AuthFlowRepository {
  Future<Result<OtpSession>> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  });

  Future<Result<AuthTokens>> verifyOtp({
    required String identifier,
    required String code,
  });

  Future<Result<void>> completeLogin();

  Future<Result<void>> completeSignup(UserProfile profile);

  Future<Result<AuthTokens>> refreshSession(String refreshToken);

  Future<Result<void>> logout(String refreshToken);
}
