import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/service_profile/data/datasources/service_profile_remote_datasource.dart';
import 'package:pms_app/features/service_profile/data/repositories/service_profile_repository_impl.dart';
import 'package:pms_app/features/service_profile/domain/repositories/service_profile_repository.dart';
import 'package:pms_app/features/service_profile/domain/usecases/get_service_profile_usecase.dart';

final serviceProfileRemoteDataSourceProvider = Provider<ServiceProfileRemoteDataSource>((ref) {
  return ServiceProfileRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final serviceProfileRepositoryProvider = Provider<ServiceProfileRepository>((ref) {
  return ServiceProfileRepositoryImpl(remoteDataSource: ref.watch(serviceProfileRemoteDataSourceProvider));
});

final getServiceProfileUseCaseProvider = Provider<GetServiceProfileUseCase>((ref) {
  return GetServiceProfileUseCase(ref.watch(serviceProfileRepositoryProvider));
});
