import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';

abstract class AccountModificationRemoteDataSource {
  Future<void> updateAdminIdentifier({required String currentIdentifier, required String newIdentifier});
}

class AccountModificationRemoteDataSourceImpl implements AccountModificationRemoteDataSource {
  final Dio _dio;

  AccountModificationRemoteDataSourceImpl(this._dio);

  @override
  Future<void> updateAdminIdentifier({required String currentIdentifier, required String newIdentifier}) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 600));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // await _dio.patch(AppConstants.endpointAdminAccountModification, data: {
      //   'currentIdentifier': currentIdentifier,
      //   'newIdentifier': newIdentifier,
      // });
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update admin account.');
    } catch (e) {
      throw ServerException('Unexpected error updating admin account: $e');
    }
  }
}
