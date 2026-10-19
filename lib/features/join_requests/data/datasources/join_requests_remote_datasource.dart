import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/join_requests/data/models/join_request_model.dart';
import 'package:pms_app/features/join_requests/data/models/received_invitation_model.dart';

abstract class JoinRequestsRemoteDataSource {
  Future<List<JoinRequestModel>> getIncoming();
  Future<void> approve(String id, {required String relation, required bool canUseDevices});
  Future<void> reject(String id, String reason);
  Future<List<ReceivedInvitationModel>> getInvitations();
  Future<void> acceptInvitation(String id);
  Future<void> declineInvitation(String id);
}

class JoinRequestsRemoteDataSourceImpl implements JoinRequestsRemoteDataSource {
  final Dio _dio;

  JoinRequestsRemoteDataSourceImpl(this._dio);

  Future<T> _run<T>(Future<T> Function() action, String fallback) async {
    try {
      return await action();
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
      throw ServerException(serverMessage ?? e.message ?? fallback);
    } catch (e) {
      throw ServerException('$fallback: $e');
    }
  }

  @override
  Future<List<JoinRequestModel>> getIncoming() => _run(() async {
        final response = await _dio.get(
          AppConstants.endpointResidencyRequestsIncoming,
          queryParameters: {'limit': 50},
        );
        final rows = response.data as List<dynamic>;
        return rows.map((r) => JoinRequestModel.fromApi(r as Map<String, dynamic>)).toList();
      }, 'Failed to load join requests');

  @override
  Future<void> approve(String id, {required String relation, required bool canUseDevices}) => _run(
        () => _dio.post(
          AppConstants.endpointResidencyRequestApprove(id),
          data: {'relation': relation, 'can_use_devices': canUseDevices},
        ),
        'Failed to approve request',
      );

  @override
  Future<void> reject(String id, String reason) => _run(
        () => _dio.post(AppConstants.endpointResidencyRequestReject(id), data: {'reason': reason}),
        'Failed to reject request',
      );

  @override
  Future<List<ReceivedInvitationModel>> getInvitations() => _run(() async {
        final response = await _dio.get(AppConstants.endpointInvitations, queryParameters: {'limit': 50});
        final rows = response.data as List<dynamic>;
        return rows.map((r) => ReceivedInvitationModel.fromApi(r as Map<String, dynamic>)).toList();
      }, 'Failed to load invitations');

  @override
  Future<void> acceptInvitation(String id) =>
      _run(() => _dio.post(AppConstants.endpointInvitationAccept(id)), 'Failed to accept invitation');

  @override
  Future<void> declineInvitation(String id) =>
      _run(() => _dio.delete(AppConstants.endpointInvitation(id)), 'Failed to decline invitation');
}
