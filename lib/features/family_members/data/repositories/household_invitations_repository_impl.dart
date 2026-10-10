import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/data/datasources/household_invitations_remote_datasource.dart';
import 'package:pms_app/features/family_members/domain/entities/invitation.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_invitations_repository.dart';

class HouseholdInvitationsRepositoryImpl implements HouseholdInvitationsRepository {
  final HouseholdInvitationsRemoteDataSource remoteDataSource;

  const HouseholdInvitationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Invitation>>> getInvitations(String householdId) async {
    try {
      final models = await remoteDataSource.getInvitations(householdId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load invitations: $e'));
    }
  }

  @override
  Future<Result<void>> createInvitation({
    required String householdId,
    required String identifier,
    required String relation,
    required bool canUseDevices,
  }) async {
    try {
      await remoteDataSource.createInvitation(
        householdId: householdId,
        identifier: identifier,
        relation: relation,
        canUseDevices: canUseDevices,
      );
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to send invitation: $e'));
    }
  }

  @override
  Future<Result<void>> deleteInvitation(String invitationId) async {
    try {
      await remoteDataSource.deleteInvitation(invitationId);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete invitation: $e'));
    }
  }
}
