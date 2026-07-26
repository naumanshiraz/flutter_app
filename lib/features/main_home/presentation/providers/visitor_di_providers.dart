import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_local_datasource.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_remote_datasource.dart';
import 'package:pms_app/features/main_home/data/repositories/visitor_repository_impl.dart';
import 'package:pms_app/features/main_home/domain/repositories/visitor_repository.dart';
import 'package:pms_app/features/main_home/domain/usecases/visitor_usecases.dart';

final visitorLocalDataSourceProvider = Provider<VisitorLocalDataSource>((ref) {
  return VisitorLocalDataSourceImpl();
});

final visitorRemoteDataSourceProvider = Provider<VisitorRemoteDataSource>((ref) {
  return VisitorRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final visitorRepositoryProvider = Provider<VisitorRepository>((ref) {
  return VisitorRepositoryImpl(
    local: ref.watch(visitorLocalDataSourceProvider),
    remote: ref.watch(visitorRemoteDataSourceProvider),
  );
});

final getVisitorSchedulesUseCaseProvider = Provider<GetVisitorSchedulesUseCase>((ref) {
  return GetVisitorSchedulesUseCase(ref.watch(visitorRepositoryProvider));
});

final addOrUpdateVisitorScheduleUseCaseProvider = Provider<AddOrUpdateVisitorScheduleUseCase>((ref) {
  return AddOrUpdateVisitorScheduleUseCase(ref.watch(visitorRepositoryProvider));
});

final deleteVisitorScheduleUseCaseProvider = Provider<DeleteVisitorScheduleUseCase>((ref) {
  return DeleteVisitorScheduleUseCase(ref.watch(visitorRepositoryProvider));
});
