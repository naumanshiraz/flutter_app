import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/family_members/data/datasources/family_members_local_datasource.dart';
import 'package:pms_app/features/family_members/data/datasources/family_members_remote_datasource.dart';
import 'package:pms_app/features/family_members/data/repositories/family_members_repository_impl.dart';
import 'package:pms_app/features/family_members/domain/repositories/family_members_repository.dart';
import 'package:pms_app/features/family_members/domain/usecases/family_members_usecases.dart';

final familyMembersLocalDataSourceProvider = Provider<FamilyMembersLocalDataSource>((ref) {
  return FamilyMembersLocalDataSourceImpl(localStorage: ref.watch(localStorageServiceProvider));
});

final familyMembersRemoteDataSourceProvider = Provider<FamilyMembersRemoteDataSource>((ref) {
  return FamilyMembersRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final familyMembersRepositoryProvider = Provider<FamilyMembersRepository>((ref) {
  return FamilyMembersRepositoryImpl(
    localDataSource: ref.watch(familyMembersLocalDataSourceProvider),
    remoteDataSource: ref.watch(familyMembersRemoteDataSourceProvider),
  );
});

final getFamilyMembersUseCaseProvider = Provider<GetFamilyMembersUseCase>((ref) {
  return GetFamilyMembersUseCase(ref.watch(familyMembersRepositoryProvider));
});

final addFamilyMemberUseCaseProvider = Provider<AddFamilyMemberUseCase>((ref) {
  return AddFamilyMemberUseCase(ref.watch(familyMembersRepositoryProvider));
});

final updateFamilyMemberUseCaseProvider = Provider<UpdateFamilyMemberUseCase>((ref) {
  return UpdateFamilyMemberUseCase(ref.watch(familyMembersRepositoryProvider));
});

final deleteFamilyMemberUseCaseProvider = Provider<DeleteFamilyMemberUseCase>((ref) {
  return DeleteFamilyMemberUseCase(ref.watch(familyMembersRepositoryProvider));
});
