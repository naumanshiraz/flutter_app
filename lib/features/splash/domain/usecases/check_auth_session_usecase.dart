import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/splash/domain/entities/auth_session.dart';
import 'package:pms_app/features/splash/domain/repositories/auth_repository.dart';

class CheckAuthSessionUseCase {
  final AuthRepository _repository;

  const CheckAuthSessionUseCase(this._repository);

  Future<Result<AuthSession>> call() => _repository.getCurrentSession();
}
