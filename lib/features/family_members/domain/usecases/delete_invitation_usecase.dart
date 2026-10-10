import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_invitations_repository.dart';

class DeleteInvitationUseCase {
  final HouseholdInvitationsRepository _repository;
  const DeleteInvitationUseCase(this._repository);

  Future<Result<void>> call(String invitationId) => _repository.deleteInvitation(invitationId);
}
