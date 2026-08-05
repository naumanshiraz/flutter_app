import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/account_termination/domain/repositories/account_termination_repository.dart';

class TerminateAccountUseCase {
  final AccountTerminationRepository _repository;
  const TerminateAccountUseCase(this._repository);

  Future<Result<void>> call({required String reason, required String feedback}) =>
      _repository.terminateAccount(reason: reason, feedback: feedback);
}
