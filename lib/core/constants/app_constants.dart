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
  // API (Swap with real backend later)
  // ---------------------------------------------------------------------
  static const String baseUrl = 'https://api.pms-app.example.com/v1';
  static const String endpointRequestOtp = '/auth/request-otp';
  static const String endpointVerifyOtp = '/auth/verify-otp';
  static const String endpointRefreshToken = '/auth/refresh-token';
  static const String endpointProfile = '/user/profile';
}
