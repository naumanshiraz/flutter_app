import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/billing_account/domain/entities/billing_account.dart';

part 'billing_account_model.freezed.dart';
part 'billing_account_model.g.dart';

@freezed
class BillingAccountModel with _$BillingAccountModel {
  const BillingAccountModel._();

  const factory BillingAccountModel({
    required String type, // 'organization' | 'individual'
    String? taxIdentificationNumber,
    String? organizationName,
    String? registrationNumber,
  }) = _BillingAccountModel;

  factory BillingAccountModel.fromJson(Map<String, dynamic> json) => _$BillingAccountModelFromJson(json);

  factory BillingAccountModel.fromEntity(BillingAccount entity) => BillingAccountModel(
        type: entity.type == BillingAccountType.organization ? 'organization' : 'individual',
        taxIdentificationNumber: entity.taxIdentificationNumber,
        organizationName: entity.organizationName,
        registrationNumber: entity.registrationNumber,
      );
}
