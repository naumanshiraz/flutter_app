import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/splash/data/models/auth_session_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthSessionModel> validateSession(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthSessionModel> validateSession(String token) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return AuthSessionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      throw ServerException(e.message ?? 'Failed to validate session.');
    } catch (e) {
      throw ServerException('Unexpected error validating session: $e');
    }
  }
}
