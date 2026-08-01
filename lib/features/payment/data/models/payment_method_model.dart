import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/payment/domain/entities/payment_method.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
class PaymentMethodModel with _$PaymentMethodModel {
  const PaymentMethodModel._();

  const factory PaymentMethodModel({
    required String id,
    required String name,
    required String subtitle,
    required String category, // 'bank' | 'wallet' | 'card' | 'other'
    required String iconAsset,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);

  PaymentMethod toEntity() => PaymentMethod(
        id: id,
        name: name,
        subtitle: subtitle,
        iconAsset: iconAsset,
        category: switch (category) {
          'wallet' => PaymentMethodCategory.onlineWallet,
          'card' => PaymentMethodCategory.cardPayment,
          'other' => PaymentMethodCategory.other,
          _ => PaymentMethodCategory.bankApplication,
        },
      );
}
