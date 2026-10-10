import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/family_members/data/datasources/household_invitations_remote_datasource.dart';
import 'package:pms_app/features/family_members/data/datasources/household_members_remote_datasource.dart';
import 'package:pms_app/features/family_members/data/repositories/household_invitations_repository_impl.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_invitations_repository.dart';
import 'package:pms_app/features/family_members/domain/usecases/create_household_invitation_usecase.dart';
import 'package:pms_app/features/family_members/domain/usecases/delete_invitation_usecase.dart';
import 'package:pms_app/features/family_members/domain/usecases/get_household_invitations_usecase.dart';
import 'package:pms_app/features/family_members/data/repositories/household_members_repository_impl.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_members_repository.dart';
import 'package:pms_app/features/family_members/domain/usecases/get_household_members_usecase.dart';

final householdMembersRemoteDataSourceProvider = Provider<HouseholdMembersRemoteDataSource>((ref) {
  return HouseholdMembersRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final householdMembersRepositoryProvider = Provider<HouseholdMembersRepository>((ref) {
  return HouseholdMembersRepositoryImpl(
    remoteDataSource: ref.watch(householdMembersRemoteDataSourceProvider),
  );
});

final getHouseholdMembersUseCaseProvider = Provider<GetHouseholdMembersUseCase>((ref) {
  return GetHouseholdMembersUseCase(ref.watch(householdMembersRepositoryProvider));
});

final householdInvitationsRemoteDataSourceProvider = Provider<HouseholdInvitationsRemoteDataSource>((ref) {
  return HouseholdInvitationsRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final householdInvitationsRepositoryProvider = Provider<HouseholdInvitationsRepository>((ref) {
  return HouseholdInvitationsRepositoryImpl(
    remoteDataSource: ref.watch(householdInvitationsRemoteDataSourceProvider),
  );
});

final getHouseholdInvitationsUseCaseProvider = Provider<GetHouseholdInvitationsUseCase>((ref) {
  return GetHouseholdInvitationsUseCase(ref.watch(householdInvitationsRepositoryProvider));
});

final createHouseholdInvitationUseCaseProvider = Provider<CreateHouseholdInvitationUseCase>((ref) {
  return CreateHouseholdInvitationUseCase(ref.watch(householdInvitationsRepositoryProvider));
});

final deleteInvitationUseCaseProvider = Provider<DeleteInvitationUseCase>((ref) {
  return DeleteInvitationUseCase(ref.watch(householdInvitationsRepositoryProvider));
});
