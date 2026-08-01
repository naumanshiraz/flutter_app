import 'package:equatable/equatable.dart';

enum BillingAccountType { organization, individual }

class BillingAccount extends Equatable {
  final BillingAccountType type;
  final String? taxIdentificationNumber;
  final String? organizationName;
  final String? registrationNumber;

  const BillingAccount({
    required this.type,
    this.taxIdentificationNumber,
    this.organizationName,
    this.registrationNumber,
  });

  @override
  List<Object?> get props => [type, taxIdentificationNumber, organizationName, registrationNumber];
}
