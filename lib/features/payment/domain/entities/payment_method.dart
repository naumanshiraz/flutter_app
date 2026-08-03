import 'package:equatable/equatable.dart';

enum PaymentMethodCategory { bankApplication, onlineWallet, cardPayment, other }

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final PaymentMethodCategory category;
  final String iconAsset;

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
