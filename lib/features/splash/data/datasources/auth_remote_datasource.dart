import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/splash/data/models/auth_session_model.dart';

/// Remote counterpart of [AuthLocalDataSource]. Not called anywhere in
/// Module 1 today (there's no backend), but implemented against the real
/// Dio client so that swapping the mocked repository for the real one
/// later is a one-line change in `injection.dart` — no UI or domain code
/// needs to change.
abstract class AuthRemoteDataSource {
  /// Validates the given [token] against the backend and returns the
  /// authoritative session state.
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
