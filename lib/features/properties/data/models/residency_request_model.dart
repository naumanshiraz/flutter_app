import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/properties/domain/entities/residency_request.dart';

part 'residency_request_model.freezed.dart';

@freezed
class ResidencyRequestModel with _$ResidencyRequestModel {
  const ResidencyRequestModel._();

  const factory ResidencyRequestModel({
    required String id,
    required String householdId,
    required String kind,
    required String status,
    required String suite,
    required String floor,
    required String unitType,
    required String buildingName,
    required String developmentName,
  }) = _ResidencyRequestModel;

  factory ResidencyRequestModel.fromApi(Map<String, dynamic> json) {
    final household = json['household'] is Map<String, dynamic> ? json['household'] as Map<String, dynamic> : json;
    String text(dynamic v) => v?.toString() ?? '';
    return ResidencyRequestModel(
      id: text(json['id']),
      householdId: text(json['household_id'] ?? household['household_id'] ?? household['id']),
      kind: text(json['kind']),
      status: text(json['status']),
      suite: text(household['suite']),
      floor: text(household['floor']),
      unitType: text(household['unit_type']),
      buildingName: text(household['building_name']),
      developmentName: text(household['development_name'] ?? household['project_name']),
    );
  }

  ResidencyRequest toEntity() => ResidencyRequest(
        id: id,
        householdId: householdId,
        kind: kind,
        status: status,
        suite: suite,
        floor: floor,
        unitType: unitType,
        buildingName: buildingName,
        developmentName: developmentName,
      );
}
