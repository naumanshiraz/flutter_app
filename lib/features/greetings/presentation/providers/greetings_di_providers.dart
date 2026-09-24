import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/greetings/data/datasources/greetings_remote_datasource.dart';
import 'package:pms_app/features/greetings/data/repositories/greetings_repository_impl.dart';
import 'package:pms_app/features/greetings/domain/repositories/greetings_repository.dart';
import 'package:pms_app/features/greetings/domain/usecases/get_greetings_usecase.dart';

final greetingsRemoteDataSourceProvider = Provider<GreetingsRemoteDataSource>((ref) {
  return GreetingsRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final greetingsRepositoryProvider = Provider<GreetingsRepository>((ref) {
  return GreetingsRepositoryImpl(remoteDataSource: ref.watch(greetingsRemoteDataSourceProvider));
});

final getGreetingsUseCaseProvider = Provider<GetGreetingsUseCase>((ref) {
  return GetGreetingsUseCase(ref.watch(greetingsRepositoryProvider));
});
