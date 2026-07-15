import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class RequestOtpUseCase {
  final AuthFlowRepository _repository;
  const RequestOtpUseCase(this._repository);

  Future<Result<OtpSession>> call({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  }) {
    return _repository.requestOtp(
      identifier: identifier,
      identifierType: identifierType,
      purpose: purpose,
    );
  }
}
