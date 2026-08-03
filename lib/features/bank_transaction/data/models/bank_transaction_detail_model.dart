import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/bank_transaction/domain/entities/bank_transaction_detail.dart';

part 'bank_transaction_detail_model.freezed.dart';
part 'bank_transaction_detail_model.g.dart';

@freezed
class BankTransactionDetailModel with _$BankTransactionDetailModel {
  const BankTransactionDetailModel._();

  const factory BankTransactionDetailModel({
    required String bankName,
    required String totalAmount,
    required String accountNumber,
    required String beneficiary,
    required String transactionCode,
  }) = _BankTransactionDetailModel;

  factory BankTransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      _$BankTransactionDetailModelFromJson(json);

  BankTransactionDetail toEntity() => BankTransactionDetail(
        bankName: bankName,
        totalAmount: totalAmount,
        accountNumber: accountNumber,
        beneficiary: beneficiary,
        transactionCode: transactionCode,
      );
}
