import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';

abstract class AccountTerminationRemoteDataSource {
  Future<void> terminateAccount({required String reason, required String feedback});
}

class AccountTerminationRemoteDataSourceImpl implements AccountTerminationRemoteDataSource {
  final Dio _dio;

  AccountTerminationRemoteDataSourceImpl(this._dio);

  @override
  Future<void> terminateAccount({required String reason, required String feedback}) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 600));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // await _dio.post(AppConstants.endpointAccountTermination, data: {
      //   'reason': reason,
      //   'feedback': feedback,
      // });
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to terminate account.');
    } catch (e) {
      throw ServerException('Unexpected error terminating account: $e');
    }
  }
}
