import 'package:hive_flutter/hive_flutter.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/services/logger_service.dart';

class LocalStorageService {
  late Box _userBox;
  late Box _settingsBox;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Must be called once during app bootstrap, before any box access.
  Future<void> init() async {
    if (_initialized) return;
    try {
      await Hive.initFlutter();
      _userBox = await Hive.openBox(AppConstants.hiveBoxUser);
      _settingsBox = await Hive.openBox(AppConstants.hiveBoxSettings);
      _initialized = true;
      AppLogger.info('LocalStorageService: Hive boxes opened successfully.');
    } catch (e, st) {
      AppLogger.error('LocalStorageService: failed to initialize Hive', e, st);
      rethrow;
    }
  }

  // ---------------------------------------------------------------------
  // Session flag
  // ---------------------------------------------------------------------
  bool get isLoggedIn =>
      _userBox.get(AppConstants.hiveKeyIsLoggedIn, defaultValue: false) as bool;

  Future<void> setLoggedIn(bool value) =>
      _userBox.put(AppConstants.hiveKeyIsLoggedIn, value);

  // ---------------------------------------------------------------------
  // Cached user profile (raw JSON string — API-ready)
  // ---------------------------------------------------------------------
  String? get cachedUserProfileJson =>
      _userBox.get(AppConstants.hiveKeyUserProfile) as String?;

  Future<void> setCachedUserProfileJson(String json) =>
      _userBox.put(AppConstants.hiveKeyUserProfile, json);

  // ---------------------------------------------------------------------
  // Onboarding flag
  // ---------------------------------------------------------------------
  bool get onboardingComplete =>
      _settingsBox.get(AppConstants.hiveKeyOnboardingComplete, defaultValue: false) as bool;

  Future<void> setOnboardingComplete(bool value) =>
      _settingsBox.put(AppConstants.hiveKeyOnboardingComplete, value);

  Future<void> clearUserData() async {
    await _userBox.clear();
  }
}
