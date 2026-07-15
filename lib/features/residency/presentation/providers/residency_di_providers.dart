import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/residency/data/datasources/residency_geo_datasource.dart';
import 'package:pms_app/features/residency/data/datasources/residency_local_datasource.dart';
import 'package:pms_app/features/residency/data/datasources/residency_remote_datasource.dart';
import 'package:pms_app/features/residency/data/repositories/residency_repository_impl.dart';
import 'package:pms_app/features/residency/domain/repositories/residency_repository.dart';
import 'package:pms_app/features/residency/domain/usecases/residency_usecases.dart';

final residencyGeoDataSourceProvider = Provider<ResidencyGeoDataSource>((ref) {
  return ResidencyGeoDataSourceImpl();
});

final residencyLocalDataSourceProvider = Provider<ResidencyLocalDataSource>((ref) {
  return ResidencyLocalDataSourceImpl(localStorage: ref.watch(localStorageServiceProvider));
});

final residencyRemoteDataSourceProvider = Provider<ResidencyRemoteDataSource>((ref) {
  return ResidencyRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final residencyRepositoryProvider = Provider<ResidencyRepository>((ref) {
  return ResidencyRepositoryImpl(
    localDataSource: ref.watch(residencyLocalDataSourceProvider),
    remoteDataSource: ref.watch(residencyRemoteDataSourceProvider),
  );
});

final getCachedResidencyAddressUseCaseProvider = Provider<GetCachedResidencyAddressUseCase>((ref) {
  return GetCachedResidencyAddressUseCase(ref.watch(residencyRepositoryProvider));
});

final saveResidencyAddressUseCaseProvider = Provider<SaveResidencyAddressUseCase>((ref) {
  return SaveResidencyAddressUseCase(ref.watch(residencyRepositoryProvider));
});
