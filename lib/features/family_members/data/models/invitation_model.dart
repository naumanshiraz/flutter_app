import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/family_members/domain/entities/invitation.dart';

part 'invitation_model.freezed.dart';
part 'invitation_model.g.dart';

@freezed
class InvitationModel with _$InvitationModel {
  const InvitationModel._();

  const factory InvitationModel({
    required String id,
    @JsonKey(name: 'household_id') @Default('') String householdId,
    @Default('') String identifier,
    @Default('') String relation,
    @JsonKey(name: 'can_use_devices') @Default(false) bool canUseDevices,
    @Default('') String status,
    @JsonKey(name: 'expires_at') String? expiresAt,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _InvitationModel;

  factory InvitationModel.fromJson(Map<String, dynamic> json) => _$InvitationModelFromJson(json);

  Invitation toEntity() => Invitation(
        id: id,
        householdId: householdId,
        identifier: identifier,
        relation: relation,
        canUseDevices: canUseDevices,
        status: status,
        expiresAt: expiresAt == null ? null : DateTime.tryParse(expiresAt!),
        createdAt: createdAt == null ? null : DateTime.tryParse(createdAt!),
      );
}
