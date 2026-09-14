import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/auth/domain/repositories/auth_flow_repository.dart';

class LogoutUseCase {
  final AuthFlowRepository _repository;
  const LogoutUseCase(this._repository);

  Future<Result<void>> call(String refreshToken) => _repository.logout(refreshToken);
}
