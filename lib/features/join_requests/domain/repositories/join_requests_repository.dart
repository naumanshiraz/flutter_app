import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';
import 'package:pms_app/features/join_requests/domain/entities/received_invitation.dart';

abstract class JoinRequestsRepository {
  Future<Result<List<JoinRequest>>> getIncoming();
  Future<Result<void>> approve(String id, {required String relation, required bool canUseDevices});
  Future<Result<void>> reject(String id, String reason);
  Future<Result<List<ReceivedInvitation>>> getInvitations();
  Future<Result<void>> acceptInvitation(String id);
  Future<Result<void>> declineInvitation(String id);
}
