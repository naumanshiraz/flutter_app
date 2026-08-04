import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class CompleteLoginUseCase {
  final AuthFlowRepository _repository;
  const CompleteLoginUseCase(this._repository);

  Future<Result<void>> call(String identifier) => _repository.completeLogin(identifier);
}

class CompleteSignupUseCase {
  final AuthFlowRepository _repository;
  const CompleteSignupUseCase(this._repository);

  Future<Result<void>> call(UserProfile profile) => _repository.completeSignup(profile);
}
