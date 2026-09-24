import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/affiliates/data/datasources/affiliates_remote_datasource.dart';
import 'package:pms_app/features/affiliates/data/repositories/affiliates_repository_impl.dart';
import 'package:pms_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:pms_app/features/affiliates/domain/usecases/affiliates_usecases.dart';

final affiliatesRemoteDataSourceProvider = Provider<AffiliatesRemoteDataSource>((ref) {
  return AffiliatesRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final affiliatesRepositoryProvider = Provider<AffiliatesRepository>((ref) {
  return AffiliatesRepositoryImpl(remoteDataSource: ref.watch(affiliatesRemoteDataSourceProvider));
});

final getAffiliatesUseCaseProvider = Provider<GetAffiliatesUseCase>((ref) {
  return GetAffiliatesUseCase(ref.watch(affiliatesRepositoryProvider));
});

final addOrUpdateAffiliateUseCaseProvider = Provider<AddOrUpdateAffiliateUseCase>((ref) {
  return AddOrUpdateAffiliateUseCase(ref.watch(affiliatesRepositoryProvider));
});

final deleteAffiliateUseCaseProvider = Provider<DeleteAffiliateUseCase>((ref) {
  return DeleteAffiliateUseCase(ref.watch(affiliatesRepositoryProvider));
});
