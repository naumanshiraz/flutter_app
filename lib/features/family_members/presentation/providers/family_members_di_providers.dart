import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/family_members/data/datasources/household_members_remote_datasource.dart';
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
