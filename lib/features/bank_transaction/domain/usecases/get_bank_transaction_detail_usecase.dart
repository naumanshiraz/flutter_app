import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/bank_transaction/domain/entities/bank_transaction_detail.dart';
import 'package:pms_app/features/bank_transaction/domain/repositories/bank_transaction_repository.dart';

class GetBankTransactionDetailUseCase {
  final BankTransactionRepository _repository;
  const GetBankTransactionDetailUseCase(this._repository);

  Future<Result<BankTransactionDetail>> call(String paymentMethodId) =>
      _repository.getBankTransactionDetail(paymentMethodId);
}
