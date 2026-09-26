import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<String> fetchCurrentUserId(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<String> fetchCurrentUserId(String token) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointAuthMe,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data as Map<String, dynamic>;
      final id = data['id'] ?? data['user_id'];
      if (id == null) {
        throw const ServerException('Malformed response from /api/auth/me.');
      }
      return id.toString();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          throw const UnauthorizedException();
        }
      throw ServerException(e.message ?? 'Failed to validate session.');
    } catch (e) {
      throw ServerException('Unexpected error validating session: $e');
    }
  }
}
