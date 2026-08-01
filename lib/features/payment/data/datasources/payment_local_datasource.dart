import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/payment/data/models/payment_method_model.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentMethodModel>> fetchPaymentMethods();
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  @override
  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return const [
        PaymentMethodModel(
          id: 'bank_transaction',
          name: 'Bank transaction',
          subtitle: 'Other payment method',
          category: 'other',
          iconAsset: 'account_balance',
        ),
      ];
    } catch (e) {
      throw CacheException('Failed to read cached payment methods: $e');
    }
  }
}
