import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/profile/data/models/editable_profile_model.dart';

abstract class ProfileLocalDataSource {
  EditableProfileModel getCachedProfile();
  Future<void> saveProfile(EditableProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorageService _localStorage;

  ProfileLocalDataSourceImpl({required LocalStorageService localStorage})
      : _localStorage = localStorage;

  Map<String, dynamic> _readRawMap() {
    final raw = _localStorage.cachedUserProfileJson;
    if (raw == null || raw.isEmpty) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  @override
  EditableProfileModel getCachedProfile() {
    try {
      final json = _readRawMap();
      return EditableProfileModel(
        name: (json['name'] as String?)?.trim() ?? '',
        email: (json['email'] as String?)?.trim() ?? '',
        phone: (json['phone'] as String?)?.trim() ?? '',
        country: json['country'] as String?,
        birthDate: json['birthDate'] != null ? DateTime.tryParse(json['birthDate'] as String) : null,
        pronouns: json['pronouns'] as String?,
        avatarPath: json['avatarPath'] as String?,
      );
    } catch (e) {
      throw CacheException('Failed to read cached profile: $e');
    }
  }

  @override
  Future<void> saveProfile(EditableProfileModel profile) async {
    try {
      final merged = _readRawMap()
        ..addAll({
          'name': profile.name,
          'email': profile.email,
          'phone': profile.phone,
          'country': profile.country,
          'birthDate': profile.birthDate?.toIso8601String(),
          'pronouns': profile.pronouns,
          'avatarPath': profile.avatarPath,
        });
      await _localStorage.setCachedUserProfileJson(jsonEncode(merged));
    } catch (e) {
      throw CacheException('Failed to save profile: $e');
    }
  }
}
