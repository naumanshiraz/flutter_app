import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/family_members/data/models/invitation_model.dart';

abstract class HouseholdInvitationsRemoteDataSource {
  Future<List<InvitationModel>> getInvitations(String householdId);
  Future<void> createInvitation({
    required String householdId,
    required String identifier,
    required String relation,
    required bool canUseDevices,
  });
  Future<void> deleteInvitation(String invitationId);
}

class HouseholdInvitationsRemoteDataSourceImpl implements HouseholdInvitationsRemoteDataSource {
  final Dio _dio;

  HouseholdInvitationsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<InvitationModel>> getInvitations(String householdId) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointHouseholdInvitations(householdId),
        queryParameters: {'limit': 50},
      );
      final rows = response.data as List<dynamic>;
      return rows.map((row) => InvitationModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map ? data['message']?.toString() : null;
      throw ServerException(serverMessage ?? e.message ?? 'Failed to load invitations.');
    } catch (e) {
      throw ServerException('Unexpected error loading invitations: $e');
    }
  }

  @override
  Future<void> createInvitation({
    required String householdId,
    required String identifier,
    required String relation,
    required bool canUseDevices,
  }) async {
    final body = {'identifier': identifier, 'relation': relation, 'can_use_devices': canUseDevices};
    try {
      await _dio.post(AppConstants.endpointHouseholdInvitations(householdId), data: body);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('DEBUG createInvitation url=${e.requestOptions.uri} body=$body status=${e.response?.statusCode} response=${e.response?.data}');
      final data = e.response?.data;
      String? serverMessage;
      if (data is Map) {
        serverMessage = (data['message'] ?? data['detail'] ?? data['error'] ?? data['errors'])?.toString();
        serverMessage ??= data.toString();
      } else if (data != null) {
        serverMessage = data.toString();
      }
      throw ServerException(serverMessage ?? e.message ?? 'Failed to send invitation.');
    } catch (e) {
      throw ServerException('Unexpected error sending invitation: $e');
    }
  }

  @override
  Future<void> deleteInvitation(String invitationId) async {
    try {
      await _dio.delete(AppConstants.endpointInvitation(invitationId));
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
      throw ServerException(serverMessage ?? e.message ?? 'Failed to delete invitation.');
    } catch (e) {
      throw ServerException('Unexpected error deleting invitation: $e');
    }
  }
}
