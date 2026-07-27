import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pms_app/core/constants/app_constants.dart';

abstract class SecureStorageService {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> clearAll();
}

class SecureStorageServiceImpl implements SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  @override
  Future<void> saveAuthToken(String token) =>
      _storage.write(key: AppConstants.secureKeyAuthToken, value: token);

  @override
  Future<String?> getAuthToken() =>
      _storage.read(key: AppConstants.secureKeyAuthToken);

  @override
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: AppConstants.secureKeyRefreshToken, value: token);

  @override
  Future<String?> getRefreshToken() =>
      _storage.read(key: AppConstants.secureKeyRefreshToken);

  @override
  Future<void> clearAll() => _storage.deleteAll();
}
