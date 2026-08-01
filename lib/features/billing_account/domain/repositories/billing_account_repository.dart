import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/billing_account/domain/entities/billing_account.dart';

abstract class BillingAccountRepository {
  Future<Result<void>> submitBillingAccount(BillingAccount account);
}
