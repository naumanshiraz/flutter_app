import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/activity_log/data/datasources/activity_log_local_datasource.dart';
import 'package:pms_app/features/activity_log/data/datasources/activity_log_remote_datasource.dart';
import 'package:pms_app/features/activity_log/data/repositories/activity_log_repository_impl.dart';
import 'package:pms_app/features/activity_log/domain/repositories/activity_log_repository.dart';
import 'package:pms_app/features/activity_log/domain/usecases/get_logs_usecase.dart';

final activityLogLocalDataSourceProvider = Provider<ActivityLogLocalDataSource>((ref) {
  return ActivityLogLocalDataSourceImpl();
});

final activityLogRemoteDataSourceProvider = Provider<ActivityLogRemoteDataSource>((ref) {
  return ActivityLogRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final activityLogRepositoryProvider = Provider<ActivityLogRepository>((ref) {
  return ActivityLogRepositoryImpl(
    localDataSource: ref.watch(activityLogLocalDataSourceProvider),
    remoteDataSource: ref.watch(activityLogRemoteDataSourceProvider),
  );
});

final getLogsUseCaseProvider = Provider<GetLogsUseCase>((ref) {
  return GetLogsUseCase(ref.watch(activityLogRepositoryProvider));
});
