import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';

part 'available_suite_model.freezed.dart';
part 'available_suite_model.g.dart';

@freezed
class AvailableSuiteModel with _$AvailableSuiteModel {
  const AvailableSuiteModel._();

  const factory AvailableSuiteModel({
    required String id,
    @Default('') String suite,
    @Default(0) int floor,
    @JsonKey(name: 'unit_type') @Default('') String unitType,
    @JsonKey(name: 'building_id') @Default('') String buildingId,
    @JsonKey(name: 'building_name') @Default('') String buildingName,
  }) = _AvailableSuiteModel;

  factory AvailableSuiteModel.fromJson(Map<String, dynamic> json) => _$AvailableSuiteModelFromJson(json);

  AvailableSuite toEntity() => AvailableSuite(
        id: id,
        suite: suite,
        floor: floor.toString(),
        unitType: unitType,
        buildingId: buildingId,
        buildingName: buildingName,
      );
}
