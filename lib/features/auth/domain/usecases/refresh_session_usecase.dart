import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/entities/auth_tokens.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class RefreshSessionUseCase {
  final AuthFlowRepository _repository;
  const RefreshSessionUseCase(this._repository);

  Future<Result<AuthTokens>> call(String refreshToken) => _repository.refreshSession(refreshToken);
}
