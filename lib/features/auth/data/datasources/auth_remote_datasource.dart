import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/auth/data/models/auth_tokens_model.dart';
import 'package:pms_app/features/auth/data/models/otp_session_model.dart';
import 'package:pms_app/features/auth/data/models/user_profile_model.dart';

abstract class AuthRemoteDataSource {
  Future<OtpSessionModel> requestOtp({
    required String identifier,
    required String purpose,
  });

  Future<AuthTokensModel> verifyOtp({required String identifier, required String code});

  Future<AuthTokensModel> refreshSession(String refreshToken);

  Future<void> logout(String refreshToken);

  Future<void> submitSignupProfile(UserProfileModel profile);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<OtpSessionModel> requestOtp({
    required String identifier,
    required String purpose,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.endpointOtpRequest,
        data: {'identifier': identifier, 'purpose': purpose},
      );
      return OtpSessionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw const ServerException('Too many codes requested. Please wait and try again.');
      }
      throw ServerException(e.message ?? 'Failed to request OTP.');
    } catch (e) {
      throw ServerException('Unexpected error requesting OTP: $e');
    }
  }

  @override
  Future<AuthTokensModel> verifyOtp({required String identifier, required String code}) async {
    try {
      final response = await _dio.post(
        AppConstants.endpointOtpVerify,
        data: {'identifier': identifier, 'code': code},
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401) {
        throw const UnauthorizedException('Invalid or expired code.');
      }
      if (status == 429) {
        throw const ServerException('Too many attempts. Please request a new code.');
      }
      throw ServerException(e.message ?? 'Failed to verify OTP.');
    } catch (e) {
      throw ServerException('Unexpected error verifying OTP: $e');
    }
  }

  @override
  Future<AuthTokensModel> refreshSession(String refreshToken) async {
    try {
      final response = await _dio.post(
        AppConstants.endpointAuthRefresh,
        data: {'refresh_token': refreshToken},
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Session expired. Please log in again.');
      }
      throw ServerException(e.message ?? 'Failed to refresh session.');
    } catch (e) {
      throw ServerException('Unexpected error refreshing session: $e');
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(
        AppConstants.endpointAuthLogout,
        data: {'refresh_token': refreshToken},
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to log out.');
    } catch (e) {
      throw ServerException('Unexpected error logging out: $e');
    }
  }

  @override
  Future<void> submitSignupProfile(UserProfileModel profile) async {
    try {
      await Future.delayed(const Duration(milliseconds: 700));

      // ---- REAL API (uncomment once `PATCH /api/app/profile` is wired) --
      // await _dio.patch(AppConstants.endpointProfile, data: profile.toJson());
    } catch (e) {
      throw ServerException('Unexpected error submitting profile: $e');
    }
  }
}
