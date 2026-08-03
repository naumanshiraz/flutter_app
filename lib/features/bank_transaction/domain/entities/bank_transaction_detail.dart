import 'package:equatable/equatable.dart';

class BankTransactionDetail extends Equatable {
  final String bankName;
  final String totalAmount;
  final String accountNumber;
  final String beneficiary;
  final String transactionCode;

  const BankTransactionDetail({
    required this.bankName,
    required this.totalAmount,
    required this.accountNumber,
    required this.beneficiary,
    required this.transactionCode,
  });

  @override
  List<Object?> get props => [bankName, totalAmount, accountNumber, beneficiary, transactionCode];
}
