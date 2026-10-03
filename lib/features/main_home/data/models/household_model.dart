import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

part 'household_model.freezed.dart';
part 'household_model.g.dart';

@freezed
class HouseholdModel with _$HouseholdModel {
  const HouseholdModel._();

  const factory HouseholdModel({
    @JsonKey(name: 'household_id') required String id,
    required String suite,
    required int floor,
    @JsonKey(name: 'unit_type') required String unitType,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'building_id') required String buildingId,
    @JsonKey(name: 'building_name') required String buildingName,
    @JsonKey(name: 'building_thumb_url') String? buildingThumbUrl,
    @JsonKey(name: 'development_thumb_url') String? developmentThumbUrl,
    double? area,
    @JsonKey(name: 'unit_of_measure') String? unitOfMeasure,
    @JsonKey(name: 'building_address') BuildingAddressModel? buildingAddress,
  }) = _HouseholdModel;

  factory HouseholdModel.fromJson(Map<String, dynamic> json) => _$HouseholdModelFromJson(json);

  Household toEntity() {
    final thumb = (buildingThumbUrl != null && buildingThumbUrl!.trim().isNotEmpty)
        ? buildingThumbUrl
        : developmentThumbUrl;

    return Household(
        id: id,
        suite: suite,
        floor: floor,
        unitType: unitType,
        claimed: isPrimary,
        buildingId: buildingId,
        buildingName: buildingName,
        imageUrl: (thumb == null || thumb.trim().isEmpty) ? null : thumb,
        area: area,
        unitOfMeasure: unitOfMeasure,
        city: buildingAddress?.city,
        country: buildingAddress?.country,
      );
  }
}

@freezed
class BuildingAddressModel with _$BuildingAddressModel {
  const factory BuildingAddressModel({
    String? city,
    String? province,
    String? country,
  }) = _BuildingAddressModel;

  factory BuildingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingAddressModelFromJson(json);
}
