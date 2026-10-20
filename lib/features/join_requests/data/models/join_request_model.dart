import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';

part 'join_request_model.freezed.dart';

String _text(dynamic v) => v?.toString() ?? '';

String householdLabel(Map<String, dynamic> json) {
  final household = json['household'] is Map<String, dynamic> ? json['household'] as Map<String, dynamic> : json;
  final parts = [
    _text(household['development_name']),
    _text(household['building_name']),
    household['suite'] == null ? '' : 'Suite ${_text(household['suite'])}',
  ].where((p) => p.isNotEmpty).toList();
  return parts.join(' · ');
}

@freezed
class JoinRequestModel with _$JoinRequestModel {
  const JoinRequestModel._();

  const factory JoinRequestModel({
    required String id,
    required String requesterName,
    required String identifier,
    required String relation,
    required String status,
    required String developmentName,
    required String buildingName,
    required String suite,
    required String floor,
    required String unitType,
  }) = _JoinRequestModel;

  factory JoinRequestModel.fromApi(Map<String, dynamic> json) {
    final requester = json['requester'] is Map<String, dynamic> ? json['requester'] as Map<String, dynamic> : const {};
    final household = json['household'] is Map<String, dynamic> ? json['household'] as Map<String, dynamic> : json;
    return JoinRequestModel(
      id: _text(json['id']),
      requesterName: _text(
        json['requester_name'] ?? json['full_name'] ?? json['name'] ?? requester['full_name'] ?? requester['name'],
      ),
      identifier: _text(json['identifier'] ?? requester['identifier'] ?? requester['email'] ?? requester['phone']),
      relation: _text(json['relation']),
      status: _text(json['status']),
      developmentName: _text(household['development_name'] ?? household['project_name']),
      buildingName: _text(household['building_name']),
      suite: _text(household['suite']),
      floor: _text(household['floor']),
      unitType: _text(household['unit_type']),
    );
  }

  JoinRequest toEntity() => JoinRequest(
        id: id,
        requesterName: requesterName,
        identifier: identifier,
        relation: relation,
        status: status,
        developmentName: developmentName,
        buildingName: buildingName,
        suite: suite,
        floor: floor,
        unitType: unitType,
      );
}
