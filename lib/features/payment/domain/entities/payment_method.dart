import 'package:equatable/equatable.dart';

/// Groups payment methods into the sections shown on `PaymentPage`.
enum PaymentMethodCategory { bankApplication, onlineWallet, cardPayment, other }

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final PaymentMethodCategory category;
  final String iconAsset; // Material icon name, mapped in the widget layer

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.iconAsset,
  });

  @override
  List<Object?> get props => [id, name, subtitle, category, iconAsset];
}
