import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/billing_account/domain/entities/billing_account.dart';
import 'package:pms_app/features/billing_account/domain/repositories/billing_account_repository.dart';

class SubmitBillingAccountUseCase {
  final BillingAccountRepository _repository;
  const SubmitBillingAccountUseCase(this._repository);

  Future<Result<void>> call(BillingAccount account) => _repository.submitBillingAccount(account);
}
