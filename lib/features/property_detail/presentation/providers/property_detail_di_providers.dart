import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/property_detail/data/datasources/property_detail_local_datasource.dart';
import 'package:pms_app/features/property_detail/data/datasources/property_detail_remote_datasource.dart';
import 'package:pms_app/features/property_detail/data/repositories/property_detail_repository_impl.dart';
import 'package:pms_app/features/property_detail/domain/repositories/property_detail_repository.dart';
import 'package:pms_app/features/property_detail/domain/usecases/property_detail_usecases.dart';

final propertyDetailLocalDataSourceProvider = Provider<PropertyDetailLocalDataSource>((ref) {
  return PropertyDetailLocalDataSourceImpl();
});

final propertyDetailRemoteDataSourceProvider = Provider<PropertyDetailRemoteDataSource>((ref) {
  return PropertyDetailRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final propertyDetailRepositoryProvider = Provider<PropertyDetailRepository>((ref) {
  return PropertyDetailRepositoryImpl(
    localDataSource: ref.watch(propertyDetailLocalDataSourceProvider),
    remoteDataSource: ref.watch(propertyDetailRemoteDataSourceProvider),
  );
});

final getPropertyDetailUseCaseProvider = Provider<GetPropertyDetailUseCase>((ref) {
  return GetPropertyDetailUseCase(ref.watch(propertyDetailRepositoryProvider));
});

final getServicesUseCaseProvider = Provider<GetServicesUseCase>((ref) {
  return GetServicesUseCase(ref.watch(propertyDetailRepositoryProvider));
});
