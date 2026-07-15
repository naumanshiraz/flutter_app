import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/features/auth/data/models/otp_session_model.dart';
import 'package:pms_app/features/auth/data/models/user_profile_model.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';

/// Talks to the backend. **There is no backend yet**, so every method
/// here is mocked with a randomly-generated code and an artificial
/// network delay instead of a real `Dio` call — but the method
/// signatures, the request "shape" (via the Freezed models), and the
/// error mapping are exactly what they'll be once a real API exists.
///
/// To go live: replace each method body with the commented-out `Dio`
/// call beneath it. Nothing above this class (repository, use cases,
/// providers, pages) needs to change.
abstract class AuthRemoteDataSource {
  Future<OtpSessionModel> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  });

  Future<void> verifyOtp({required String identifier, required String code});

  Future<void> submitSignupProfile(UserProfileModel profile);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final Random _random = Random();

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<OtpSessionModel> requestOtp({
    required String identifier,
    required IdentifierType identifierType,
    required OtpPurpose purpose,
  }) async {
    try {
      // ---- MOCK (no backend yet): random 6-digit code -----------------
      await Future.delayed(const Duration(milliseconds: 900));
      final code = (_random.nextInt(900000) + 100000).toString();
      AppLogger.info(
        'MOCK OTP — requestOtp("$identifier"): generated code $code '
        '(this is logged only because there is no real SMS/email backend yet)',
      );

      return OtpSessionModel(
        identifier: identifier,
        identifierType: identifierType == IdentifierType.email ? 'email' : 'phone',
        purpose: purpose == OtpPurpose.signup ? 'signup' : 'login',
        code: code,
        expiresAt: DateTime.now().add(AppConstants.otpResendDuration),
      );

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.post(
      //   AppConstants.endpointRequestOtp,
      //   data: {
      //     'identifier': identifier,
      //     'identifierType': identifierType == IdentifierType.email ? 'email' : 'phone',
      //     'purpose': purpose == OtpPurpose.signup ? 'signup' : 'login',
      //   },
      // );
      // return OtpSessionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to request OTP.');
    } catch (e) {
      throw ServerException('Unexpected error requesting OTP: $e');
    }
  }

  @override
  Future<void> verifyOtp({required String identifier, required String code}) async {
    try {
      // ---- MOCK: nothing to call server-side; local repo verifies the
      // stored session against `code` directly. Kept here only so the
      // interface already matches the real endpoint shape.
      await Future.delayed(const Duration(milliseconds: 500));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.post(
      //   AppConstants.endpointVerifyOtp,
      //   data: {'identifier': identifier, 'code': code},
      // );
      // if (response.statusCode != 200) throw const ServerException();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Invalid or expired code.');
      }
      throw ServerException(e.message ?? 'Failed to verify OTP.');
    } catch (e) {
      throw ServerException('Unexpected error verifying OTP: $e');
    }
  }

  @override
  Future<void> submitSignupProfile(UserProfileModel profile) async {
    try {
      // ---- MOCK: simulate a brief save. ---------------------------------
      await Future.delayed(const Duration(milliseconds: 700));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // await _dio.post(AppConstants.endpointProfile, data: profile.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to submit profile.');
    } catch (e) {
      throw ServerException('Unexpected error submitting profile: $e');
    }
  }
}
