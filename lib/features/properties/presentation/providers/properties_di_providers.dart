import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/properties/data/datasources/properties_local_datasource.dart';
import 'package:pms_app/features/properties/data/datasources/properties_remote_datasource.dart';
import 'package:pms_app/features/properties/data/repositories/properties_repository_impl.dart';
import 'package:pms_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:pms_app/features/properties/domain/usecases/properties_usecases.dart';

final propertiesLocalDataSourceProvider = Provider<PropertiesLocalDataSource>((ref) {
  return PropertiesLocalDataSourceImpl(localStorage: ref.watch(localStorageServiceProvider));
});

final propertiesRemoteDataSourceProvider = Provider<PropertiesRemoteDataSource>((ref) {
  return PropertiesRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final propertiesRepositoryProvider = Provider<PropertiesRepository>((ref) {
  return PropertiesRepositoryImpl(
    localDataSource: ref.watch(propertiesLocalDataSourceProvider),
    remoteDataSource: ref.watch(propertiesRemoteDataSourceProvider),
  );
});

final getPropertiesUseCaseProvider = Provider<GetPropertiesUseCase>((ref) {
  return GetPropertiesUseCase(ref.watch(propertiesRepositoryProvider));
});

final addPropertyUseCaseProvider = Provider<AddPropertyUseCase>((ref) {
  return AddPropertyUseCase(ref.watch(propertiesRepositoryProvider));
});

final updatePropertyUseCaseProvider = Provider<UpdatePropertyUseCase>((ref) {
  return UpdatePropertyUseCase(ref.watch(propertiesRepositoryProvider));
});

final deletePropertyUseCaseProvider = Provider<DeletePropertyUseCase>((ref) {
  return DeletePropertyUseCase(ref.watch(propertiesRepositoryProvider));
});
