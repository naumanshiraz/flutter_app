import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';

part 'affiliate_model.freezed.dart';
part 'affiliate_model.g.dart';

@freezed
class AffiliateModel with _$AffiliateModel {
  const AffiliateModel._();

  const factory AffiliateModel({
    required String id,
    @JsonKey(name: 'property_id') required String propertyId,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    String? relationship,
    @Default('Pending') String status,
  }) = _AffiliateModel;

  factory AffiliateModel.fromJson(Map<String, dynamic> json) => _$AffiliateModelFromJson(json);

  factory AffiliateModel.fromEntity(Affiliate entity) => AffiliateModel(
        id: entity.id,
        propertyId: entity.propertyId,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        relationship: entity.relationship,
        status: entity.status,
      );

  Affiliate toEntity() => Affiliate(
        id: id,
        propertyId: propertyId,
        name: name,
        email: email,
        phone: phone,
        relationship: relationship,
        status: status,
      );
}
