import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class VerifyOtpUseCase {
  final AuthFlowRepository _repository;
  const VerifyOtpUseCase(this._repository);

  Future<Result<bool>> call({
    required String identifier,
    required String code,
  }) {
    return _repository.verifyOtp(identifier: identifier, code: code);
  }
}
