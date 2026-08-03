import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/bank_transaction/data/models/bank_transaction_detail_model.dart';

abstract class BankTransactionRemoteDataSource {
  Future<BankTransactionDetailModel> getBankTransactionDetail(String paymentMethodId);
}

class BankTransactionRemoteDataSourceImpl implements BankTransactionRemoteDataSource {
  final Dio _dio;
  BankTransactionRemoteDataSourceImpl(this._dio);

  // Matches the bank ids from PaymentRemoteDataSource's mock list.
  static const Map<String, String> _bankNames = {
    'trade_dev_bank': 'Trade Development Bank',
    'khan_bank': 'Khan Bank',
    'khas_bank': 'Khas Bank',
    'm_bank': 'M Bank',
    'bank_transaction': 'Bank transaction',
  };

  @override
  Future<BankTransactionDetailModel> getBankTransactionDetail(String paymentMethodId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return BankTransactionDetailModel(
        bankName: _bankNames[paymentMethodId] ?? 'Bank',
        totalAmount: 'MNT 45,000',
        accountNumber: '418 568 308',
        beneficiary: 'Khos urguu',
        transactionCode: 'KHU050524854',
      );

      // REAL API (uncomment once available)
      // final response = await _dio.get('/payment-methods/$paymentMethodId/bank-transaction');
      // return BankTransactionDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch bank transaction detail.');
    } catch (e) {
      throw ServerException('Unexpected error fetching bank transaction detail: $e');
    }
  }
}
