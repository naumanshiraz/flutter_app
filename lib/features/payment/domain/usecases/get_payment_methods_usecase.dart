import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/payment/domain/entities/payment_method.dart';
import 'package:pms_app/features/payment/domain/repositories/payment_repository.dart';

class GetPaymentMethodsUseCase {
  final PaymentRepository _repository;
  const GetPaymentMethodsUseCase(this._repository);

  Future<Result<List<PaymentMethod>>> call() => _repository.getPaymentMethods();
}
