import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/invitation.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_invitations_repository.dart';

class GetHouseholdInvitationsUseCase {
  final HouseholdInvitationsRepository _repository;
  const GetHouseholdInvitationsUseCase(this._repository);

  Future<Result<List<Invitation>>> call(String householdId) => _repository.getInvitations(householdId);
}
