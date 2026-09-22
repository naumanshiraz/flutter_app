/// Centralized application constants.
class AppConstants {
  AppConstants._();

  // ---------------------------------------------------------------------
  // App Info
  // ---------------------------------------------------------------------
  static const String appName = 'Property Management System';
  static const String appVersion = '1.0.0';

  // ---------------------------------------------------------------------
  // Storage Keys (Secure Storage)
  // ---------------------------------------------------------------------
  static const String secureKeyAuthToken = 'secure_auth_token';
  static const String secureKeyRefreshToken = 'secure_refresh_token';

  // ---------------------------------------------------------------------
  // Storage Keys (Hive Boxes)
  // ---------------------------------------------------------------------
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveKeyIsLoggedIn = 'is_logged_in';
  static const String hiveKeyUserProfile = 'user_profile';
  static const String hiveKeyOnboardingComplete = 'onboarding_complete';

  // ---------------------------------------------------------------------
  // Timing
  // ---------------------------------------------------------------------
  static const Duration splashMinimumDuration = Duration(milliseconds: 1800);
  static const Duration otpResendDuration = Duration(seconds: 120);
  static const Duration apiTimeout = Duration(seconds: 30);

  // ---------------------------------------------------------------------
  // API — Dobu Mobile API (Estavex), resident surface.
  // Staging default; local demo stack is http://localhost:3000.
  // ---------------------------------------------------------------------
  static const String baseUrl = 'https://api.estavex.com';
  static const String endpointOtpRequest = '/api/auth/otp/request';
  static const String endpointOtpVerify = '/api/auth/otp/verify';
  static const String endpointAuthMe = '/api/auth/me';
  static const String endpointAuthRefresh = '/api/auth/refresh';
  static const String endpointAuthLogout = '/api/auth/logout';
  static const String endpointProfile = '/api/app/profile';
  static const String endpointProfileAvatar = '/api/app/profile/avatar';
  static const String endpointCampuses = '/api/app/campuses';
  
  /// GET /api/app/campuses/{campusId}/households
  static String endpointCampusHouseholds(String campusId) =>
      '/api/app/campuses/$campusId/households';
}
