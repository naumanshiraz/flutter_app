import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/billing_account/data/models/billing_account_model.dart';

abstract class BillingAccountLocalDataSource {
  Future<void> persistBillingAccount(BillingAccountModel model);
}

class BillingAccountLocalDataSourceImpl implements BillingAccountLocalDataSource {
  BillingAccountModel? _lastSubmitted;

  @override
  Future<void> persistBillingAccount(BillingAccountModel model) async {
    try {
      _lastSubmitted = model;
    } catch (e) {
      throw CacheException('Failed to persist billing account: $e');
    }
  }
}
