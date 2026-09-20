import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';

part 'residency_address_model.freezed.dart';
part 'residency_address_model.g.dart';

@freezed
class ResidencyAddressModel with _$ResidencyAddressModel {
  const ResidencyAddressModel._();

  const factory ResidencyAddressModel({
    String? campusId,
    String? campusName,
    String? country,
    String? city,
  }) = _ResidencyAddressModel;

  factory ResidencyAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ResidencyAddressModelFromJson(json);

  factory ResidencyAddressModel.fromEntity(ResidencyAddress entity) => ResidencyAddressModel(
        campusId: entity.campusId,
        campusName: entity.campusName,
        country: entity.country,
        city: entity.city,
      );

  ResidencyAddress toEntity() => ResidencyAddress(
        campusId: campusId,
        campusName: campusName,
        country: country,
        city: city,
      );
}
