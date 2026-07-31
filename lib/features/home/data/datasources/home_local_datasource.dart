import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/home/data/models/profile_summary_model.dart';

abstract class HomeLocalDataSource {
  ProfileSummaryModel? getCachedProfile();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final LocalStorageService _localStorage;

  HomeLocalDataSourceImpl({required LocalStorageService localStorage})
      : _localStorage = localStorage;

  @override
  ProfileSummaryModel? getCachedProfile() {
    try {
      final raw = _localStorage.cachedUserProfileJson;
      if (raw == null || raw.isEmpty) return null;

      final json = jsonDecode(raw) as Map<String, dynamic>;
      final name = (json['name'] as String?)?.trim();
      final email = (json['email'] as String?)?.trim();
      final phone = (json['phone'] as String?)?.trim();
      final avatarPath = (json['avatarPath'] as String?)?.trim();
      if (name == null || name.isEmpty) return null;

      return ProfileSummaryModel(
        name: name,
        email: email ?? '',
        phone: phone ?? '',
        avatarUrl: (avatarPath != null && avatarPath.isNotEmpty) ? avatarPath : null,
      );
    } catch (e) {
      throw CacheException('Failed to read cached profile: $e');
    }
  }
}
