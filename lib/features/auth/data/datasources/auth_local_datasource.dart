import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';
import 'package:pms_app/features/auth/data/models/otp_session_model.dart';
import 'package:pms_app/features/auth/data/models/user_profile_model.dart';

/// Holds transient flow state (the currently pending OTP challenge) and
/// persists the durable outcome (auth token, login flag, cached profile)
/// once the flow completes.
///
/// The pending session lives in memory only — by design. It's re-created
/// every time `requestOtp` runs (including on resend), and there is
/// nothing worth surviving an app restart mid-verification; the user
/// would simply request a fresh code.
abstract class AuthLocalDataSource {
  Future<void> savePendingOtpSession(OtpSessionModel session);
  OtpSessionModel? getPendingOtpSession(String identifier);
  Future<void> clearPendingOtpSession();

  Future<void> persistAuthenticatedSession({String? cachedProfileJson});
  Future<void> persistOnboardingProfile(UserProfileModel profile);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;

  OtpSessionModel? _pendingSession;

  AuthLocalDataSourceImpl({
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
  })  : _secureStorage = secureStorage,
        _localStorage = localStorage;

  @override
  Future<void> savePendingOtpSession(OtpSessionModel session) async {
    _pendingSession = session;
  }

  @override
  OtpSessionModel? getPendingOtpSession(String identifier) {
    final session = _pendingSession;
    if (session == null || session.identifier != identifier) return null;
    return session;
  }

  @override
  Future<void> clearPendingOtpSession() async {
    _pendingSession = null;
  }

  @override
  Future<void> persistAuthenticatedSession({String? cachedProfileJson}) async {
    try {
      await _secureStorage
          .saveAuthToken('mock-token-${DateTime.now().millisecondsSinceEpoch}');
      await _localStorage.setLoggedIn(true);
      if (cachedProfileJson != null) {
        await _localStorage.setCachedUserProfileJson(cachedProfileJson);
      }
    } catch (e) {
      throw CacheException('Failed to persist authenticated session: $e');
    }
  }

  @override
  Future<void> persistOnboardingProfile(UserProfileModel profile) async {
    try {
      await _localStorage.setCachedUserProfileJson(jsonEncode(profile.toJson()));
      await _localStorage.setOnboardingComplete(true);
    } catch (e) {
      throw CacheException('Failed to persist onboarding profile: $e');
    }
  }
}
