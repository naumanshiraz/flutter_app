import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/concierge/data/datasources/concierge_remote_datasource.dart';
import 'package:pms_app/features/concierge/data/repositories/concierge_repository_impl.dart';
import 'package:pms_app/features/concierge/domain/repositories/concierge_repository.dart';
import 'package:pms_app/features/concierge/domain/usecases/get_concierge_services_usecase.dart';

final conciergeRemoteDataSourceProvider = Provider<ConciergeRemoteDataSource>((ref) {
  return ConciergeRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final conciergeRepositoryProvider = Provider<ConciergeRepository>((ref) {
  return ConciergeRepositoryImpl(remoteDataSource: ref.watch(conciergeRemoteDataSourceProvider));
});

final getConciergeServicesUseCaseProvider = Provider<GetConciergeServicesUseCase>((ref) {
  return GetConciergeServicesUseCase(ref.watch(conciergeRepositoryProvider));
});
