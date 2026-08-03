import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';

part 'residency_address_model.freezed.dart';
part 'residency_address_model.g.dart';

@freezed
class ResidencyAddressModel with _$ResidencyAddressModel {
  const ResidencyAddressModel._();

  const factory ResidencyAddressModel({
    String? country,
    String? city,
    String? district,
    String? khoroo,
    String? residence,
  }) = _ResidencyAddressModel;

  factory ResidencyAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ResidencyAddressModelFromJson(json);

  factory ResidencyAddressModel.fromEntity(ResidencyAddress entity) => ResidencyAddressModel(
        country: entity.country,
        city: entity.city,
        district: entity.district,
        khoroo: entity.khoroo,
        residence: entity.residence,
      );

  ResidencyAddress toEntity() => ResidencyAddress(
        country: country,
        city: city,
        district: district,
        khoroo: khoroo,
        residence: residence,
      );
}
