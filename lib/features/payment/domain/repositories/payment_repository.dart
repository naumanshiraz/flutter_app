import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/payment/domain/entities/payment_method.dart';

abstract class PaymentRepository {
  Future<Result<List<PaymentMethod>>> getPaymentMethods();
}
