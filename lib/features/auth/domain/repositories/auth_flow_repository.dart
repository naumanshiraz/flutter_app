import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';

abstract class AuthFlowRepository {
  Future<Result<OtpSession>> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  });

  Future<Result<bool>> verifyOtp({
    required String identifier,
    required String code,
  });

  Future<Result<void>> completeSignup(UserProfile profile);

  Future<Result<void>> completeLogin(String identifier);
}
