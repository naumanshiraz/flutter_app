import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/payment/data/models/payment_method_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;
  PaymentRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockMethods = [
    {'id': 'trade_dev_bank', 'name': 'Trade Development Bank', 'subtitle': 'Pay by mobile app', 'category': 'bank', 'iconAsset': 'TDB_logo.png'},
    {'id': 'khan_bank', 'name': 'Khan Bank', 'subtitle': 'Pay by mobile app', 'category': 'bank', 'iconAsset': 'khan_bank_logo.png'},
    {'id': 'khas_bank', 'name': 'Khas Bank', 'subtitle': 'Pay by mobile app', 'category': 'bank', 'iconAsset': 'khas_bank_logo.png'},
    {'id': 'm_bank', 'name': 'M Bank', 'subtitle': 'Pay by mobile app', 'category': 'bank', 'iconAsset': 'm_bank_logo.png'},
    {'id': 'toki', 'name': 'Toki', 'subtitle': 'Online wallet', 'category': 'wallet', 'iconAsset': 'toki_logo.jpg'},
    {'id': 'social_pay', 'name': 'Social Pay', 'subtitle': 'Online wallet', 'category': 'wallet', 'iconAsset': 'social_pay_logo.png'},
    {'id': 'monpay', 'name': 'Monpay', 'subtitle': 'Online wallet', 'category': 'wallet', 'iconAsset': 'monpay_logo.jpg'},
    {'id': 'wechat', 'name': 'Wechat', 'subtitle': 'Online wallet', 'category': 'wallet', 'iconAsset': 'wechat_logo.jpg'},
    {'id': 'intl_cards', 'name': 'International cards', 'subtitle': 'Visa Master Amex', 'category': 'card', 'iconAsset': 'intl_card.png'},
    {'id': 'britto_card', 'name': 'Britto card', 'subtitle': 'Card payment', 'category': 'card', 'iconAsset': 'TDB_logo.png'},
    {'id': 'khan_card', 'name': 'Khan card', 'subtitle': 'Card payment', 'category': 'card', 'iconAsset': 'khan_bank_logo.png'},
    {'id': 'bank_transaction', 'name': 'Bank transaction', 'subtitle': 'Other payment method', 'category': 'other', 'iconAsset': 'bank_icon.jpg'},
  ];

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    try {
      // MOCK: no backend/payment integration yet.
      await Future.delayed(const Duration(milliseconds: 400));
      return _mockMethods.map(PaymentMethodModel.fromJson).toList();

      // REAL API (uncomment once available)
      // final response = await _dio.get('/payment-methods');
      // final data = response.data as List<dynamic>;
      // return data.map((j) => PaymentMethodModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch payment methods.');
    } catch (e) {
      throw ServerException('Unexpected error fetching payment methods: $e');
    }
  }
}
