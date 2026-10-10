import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_invitations_repository.dart';

class CreateHouseholdInvitationUseCase {
  final HouseholdInvitationsRepository _repository;
  const CreateHouseholdInvitationUseCase(this._repository);

  Future<Result<void>> call({
    required String householdId,
    required String identifier,
    required String relation,
    bool canUseDevices = false,
  }) =>
      _repository.createInvitation(
        householdId: householdId,
        identifier: identifier,
        relation: relation,
        canUseDevices: canUseDevices,
      );
}
