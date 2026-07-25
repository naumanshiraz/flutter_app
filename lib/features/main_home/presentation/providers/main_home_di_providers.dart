import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/main_home/data/datasources/main_home_local_datasource.dart';
import 'package:pms_app/features/main_home/data/datasources/main_home_remote_datasource.dart';
import 'package:pms_app/features/main_home/data/repositories/main_home_repository_impl.dart';
import 'package:pms_app/features/main_home/domain/repositories/main_home_repository.dart';
import 'package:pms_app/features/main_home/domain/usecases/get_controls_usecase.dart';

final mainHomeLocalDataSourceProvider = Provider<MainHomeLocalDataSource>((ref) {
  return MainHomeLocalDataSourceImpl();
});

final mainHomeRemoteDataSourceProvider = Provider<MainHomeRemoteDataSource>((ref) {
  // Uses project's dio provider (wired in core/di)
  return MainHomeRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final mainHomeRepositoryProvider = Provider<MainHomeRepository>((ref) {
  return MainHomeRepositoryImpl(
    localDataSource: ref.watch(mainHomeLocalDataSourceProvider),
    remoteDataSource: ref.watch(mainHomeRemoteDataSourceProvider),
  );
});

final getControlsUseCaseProvider = Provider<GetControlsUseCase>((ref) {
  return GetControlsUseCase(ref.watch(mainHomeRepositoryProvider));
});