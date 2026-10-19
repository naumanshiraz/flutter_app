import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';
import 'package:pms_app/features/join_requests/domain/entities/received_invitation.dart';
import 'package:pms_app/features/join_requests/domain/repositories/join_requests_repository.dart';

class GetIncomingJoinRequestsUseCase {
  final JoinRequestsRepository _repository;
  const GetIncomingJoinRequestsUseCase(this._repository);
  Future<Result<List<JoinRequest>>> call() => _repository.getIncoming();
}

class ApproveJoinRequestUseCase {
  final JoinRequestsRepository _repository;
  const ApproveJoinRequestUseCase(this._repository);
  Future<Result<void>> call(String id, {String relation = 'family', bool canUseDevices = false}) =>
      _repository.approve(id, relation: relation, canUseDevices: canUseDevices);
}

class RejectJoinRequestUseCase {
  final JoinRequestsRepository _repository;
  const RejectJoinRequestUseCase(this._repository);
  Future<Result<void>> call(String id, String reason) => _repository.reject(id, reason);
}

class GetReceivedInvitationsUseCase {
  final JoinRequestsRepository _repository;
  const GetReceivedInvitationsUseCase(this._repository);
  Future<Result<List<ReceivedInvitation>>> call() => _repository.getInvitations();
}

class AcceptInvitationUseCase {
  final JoinRequestsRepository _repository;
  const AcceptInvitationUseCase(this._repository);
  Future<Result<void>> call(String id) => _repository.acceptInvitation(id);
}

class DeclineInvitationUseCase {
  final JoinRequestsRepository _repository;
  const DeclineInvitationUseCase(this._repository);
  Future<Result<void>> call(String id) => _repository.declineInvitation(id);
}
