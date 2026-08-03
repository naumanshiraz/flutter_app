import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';
import 'package:pms_app/features/splash/data/models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthSessionModel> getLocalSession();
  Future<void> persistSession(AuthSessionModel session);
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorage;
  final LocalStorageService _localStorage;

  AuthLocalDataSourceImpl({
    required SecureStorageService secureStorage,
    required LocalStorageService localStorage,
  })  : _secureStorage = secureStorage,
        _localStorage = localStorage;

  @override
  Future<AuthSessionModel> getLocalSession() async {
    try {
      final token = await _secureStorage.getAuthToken();
      final loggedInFlag = _localStorage.isLoggedIn;
      final hasValidSession = loggedInFlag && token != null && token.isNotEmpty;

      return AuthSessionModel(
        isAuthenticated: hasValidSession,
        userId: hasValidSession ? 'mock-user-id' : null,
        onboardingComplete: _localStorage.onboardingComplete,
      );
    } catch (e) {
      throw CacheException('Failed to read local session: $e');
    }
  }

  @override
  Future<void> persistSession(AuthSessionModel session) async {
    try {
      await _localStorage.setLoggedIn(session.isAuthenticated);
      if (session.isAuthenticated) {
        await _secureStorage.saveAuthToken('mock-token-${DateTime.now().millisecondsSinceEpoch}');
      }
    } catch (e) {
      throw CacheException('Failed to persist session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _secureStorage.clearAll();
      await _localStorage.setLoggedIn(false);
      await _localStorage.clearUserData();
    } catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }
}
