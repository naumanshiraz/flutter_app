import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/invitation.dart';

abstract class HouseholdInvitationsRepository {
  Future<Result<List<Invitation>>> getInvitations(String householdId);
  Future<Result<void>> deleteInvitation(String invitationId);
  Future<Result<void>> createInvitation({
    required String householdId,
    required String identifier,
    required String relation,
    required bool canUseDevices,
  });
}
