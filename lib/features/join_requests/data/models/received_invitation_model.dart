import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/join_requests/data/models/join_request_model.dart';
import 'package:pms_app/features/join_requests/domain/entities/received_invitation.dart';

part 'received_invitation_model.freezed.dart';

@freezed
class ReceivedInvitationModel with _$ReceivedInvitationModel {
  const ReceivedInvitationModel._();

  const factory ReceivedInvitationModel({
    required String id,
    required String inviterName,
    required String relation,
    required String status,
    required String household,
    String? expiresAt,
  }) = _ReceivedInvitationModel;

  factory ReceivedInvitationModel.fromApi(Map<String, dynamic> json) {
    final inviter = json['inviter'] is Map<String, dynamic> ? json['inviter'] as Map<String, dynamic> : const {};
    return ReceivedInvitationModel(
      id: json['id']?.toString() ?? '',
      inviterName: (json['invited_by_name'] ?? json['inviter_name'] ?? json['invited_by'] ?? inviter['full_name'] ?? inviter['name'] ?? '')
          .toString(),
      relation: json['relation']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      household: householdLabel(json),
      expiresAt: json['expires_at']?.toString(),
    );
  }

  ReceivedInvitation toEntity() => ReceivedInvitation(
        id: id,
        inviterName: inviterName,
        relation: relation,
        status: status,
        household: household,
        expiresAt: expiresAt == null ? null : DateTime.tryParse(expiresAt!),
      );
}
