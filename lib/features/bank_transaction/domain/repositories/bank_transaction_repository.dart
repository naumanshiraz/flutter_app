import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/bank_transaction/domain/entities/bank_transaction_detail.dart';

abstract class BankTransactionRepository {
  Future<Result<BankTransactionDetail>> getBankTransactionDetail(String paymentMethodId);
}
