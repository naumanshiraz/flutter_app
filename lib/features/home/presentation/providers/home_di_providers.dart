import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/home/data/datasources/home_local_datasource.dart';
import 'package:pms_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:pms_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:pms_app/features/home/domain/repositories/home_repository.dart';
import 'package:pms_app/features/home/domain/usecases/home_usecases.dart';

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl(localStorage: ref.watch(localStorageServiceProvider));
});

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    localDataSource: ref.watch(homeLocalDataSourceProvider),
    remoteDataSource: ref.watch(homeRemoteDataSourceProvider),
  );
});

final getProfileSummaryUseCaseProvider = Provider<GetProfileSummaryUseCase>((ref) {
  return GetProfileSummaryUseCase(ref.watch(homeRepositoryProvider));
});

final getPropertyListingsUseCaseProvider = Provider<GetPropertyListingsUseCase>((ref) {
  return GetPropertyListingsUseCase(ref.watch(homeRepositoryProvider));
});
