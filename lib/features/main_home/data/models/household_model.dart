import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

part 'household_model.freezed.dart';
part 'household_model.g.dart';

@freezed
class HouseholdModel with _$HouseholdModel {
  const HouseholdModel._();

  const factory HouseholdModel({
    required String id,
    required String suite,
    required int floor,
    @JsonKey(name: 'unit_type') required String unitType,
    @Default(false) bool claimed,
    @JsonKey(name: 'building_id') required String buildingId,
    @JsonKey(name: 'building_name') required String buildingName,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _HouseholdModel;

  factory HouseholdModel.fromJson(Map<String, dynamic> json) => _$HouseholdModelFromJson(json);

  Household toEntity() => Household(
        id: id,
        suite: suite,
        floor: floor,
        unitType: unitType,
        claimed: claimed,
        buildingId: buildingId,
        buildingName: buildingName,
        imageUrl: (imageUrl == null || imageUrl!.trim().isEmpty) ? null : imageUrl,
      );
}
