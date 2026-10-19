import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/join_requests/data/datasources/join_requests_remote_datasource.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';
import 'package:pms_app/features/join_requests/domain/entities/received_invitation.dart';
import 'package:pms_app/features/join_requests/domain/repositories/join_requests_repository.dart';

class JoinRequestsRepositoryImpl implements JoinRequestsRepository {
  final JoinRequestsRemoteDataSource _remote;

  const JoinRequestsRepositoryImpl({required JoinRequestsRemoteDataSource remoteDataSource})
      : _remote = remoteDataSource;

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('$e'));
    }
  }

  @override
  Future<Result<List<JoinRequest>>> getIncoming() =>
      _guard(() async => (await _remote.getIncoming()).map((m) => m.toEntity()).toList());

  @override
  Future<Result<void>> approve(String id, {required String relation, required bool canUseDevices}) =>
      _guard(() => _remote.approve(id, relation: relation, canUseDevices: canUseDevices));

  @override
  Future<Result<void>> reject(String id, String reason) => _guard(() => _remote.reject(id, reason));

  @override
  Future<Result<List<ReceivedInvitation>>> getInvitations() =>
      _guard(() async => (await _remote.getInvitations()).map((m) => m.toEntity()).toList());

  @override
  Future<Result<void>> acceptInvitation(String id) => _guard(() => _remote.acceptInvitation(id));

  @override
  Future<Result<void>> declineInvitation(String id) => _guard(() => _remote.declineInvitation(id));
}
