import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/main_home/data/datasources/household_remote_datasource.dart';
import 'package:pms_app/features/main_home/data/repositories/household_repository_impl.dart';
import 'package:pms_app/features/main_home/domain/repositories/household_repository.dart';
import 'package:pms_app/features/main_home/domain/usecases/get_households_usecase.dart';

final householdRemoteDataSourceProvider = Provider<HouseholdRemoteDataSource>((ref) {
  return HouseholdRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  return HouseholdRepositoryImpl(remoteDataSource: ref.watch(householdRemoteDataSourceProvider));
});

final getHouseholdsUseCaseProvider = Provider<GetHouseholdsUseCase>((ref) {
  return GetHouseholdsUseCase(ref.watch(householdRepositoryProvider));
});
