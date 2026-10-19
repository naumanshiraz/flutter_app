import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/join_requests/data/datasources/join_requests_remote_datasource.dart';
import 'package:pms_app/features/join_requests/data/repositories/join_requests_repository_impl.dart';
import 'package:pms_app/features/join_requests/domain/repositories/join_requests_repository.dart';
import 'package:pms_app/features/join_requests/domain/usecases/join_requests_usecases.dart';

final joinRequestsRemoteDataSourceProvider = Provider<JoinRequestsRemoteDataSource>((ref) {
  return JoinRequestsRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final joinRequestsRepositoryProvider = Provider<JoinRequestsRepository>((ref) {
  return JoinRequestsRepositoryImpl(remoteDataSource: ref.watch(joinRequestsRemoteDataSourceProvider));
});

final getIncomingJoinRequestsUseCaseProvider = Provider<GetIncomingJoinRequestsUseCase>((ref) {
  return GetIncomingJoinRequestsUseCase(ref.watch(joinRequestsRepositoryProvider));
});

final approveJoinRequestUseCaseProvider = Provider<ApproveJoinRequestUseCase>((ref) {
  return ApproveJoinRequestUseCase(ref.watch(joinRequestsRepositoryProvider));
});

final rejectJoinRequestUseCaseProvider = Provider<RejectJoinRequestUseCase>((ref) {
  return RejectJoinRequestUseCase(ref.watch(joinRequestsRepositoryProvider));
});

final getReceivedInvitationsUseCaseProvider = Provider<GetReceivedInvitationsUseCase>((ref) {
  return GetReceivedInvitationsUseCase(ref.watch(joinRequestsRepositoryProvider));
});

final acceptInvitationUseCaseProvider = Provider<AcceptInvitationUseCase>((ref) {
  return AcceptInvitationUseCase(ref.watch(joinRequestsRepositoryProvider));
});

final declineInvitationUseCaseProvider = Provider<DeclineInvitationUseCase>((ref) {
  return DeclineInvitationUseCase(ref.watch(joinRequestsRepositoryProvider));
});
