import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

/// Called right after OTP verification succeeds for a *returning* user
/// (Login flow) — no profile to collect, just marks the session active.
class CompleteLoginUseCase {
  final AuthFlowRepository _repository;
  const CompleteLoginUseCase(this._repository);

  Future<Result<void>> call(String identifier) => _repository.completeLogin(identifier);
}

/// Called after the final onboarding step (Location) for a *new* user
/// (Sign up flow) — persists the collected profile and marks the
/// session active + onboarded.
class CompleteSignupUseCase {
  final AuthFlowRepository _repository;
  const CompleteSignupUseCase(this._repository);

  Future<Result<void>> call(UserProfile profile) => _repository.completeSignup(profile);
}
