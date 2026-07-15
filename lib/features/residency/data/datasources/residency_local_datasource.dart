import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/residency/data/models/residency_address_model.dart';

/// Reads/writes into the same cached-profile JSON blob every other
/// profile-adjacent module uses (`LocalStorageService.cachedUserProfileJson`),
/// under a nested `residency` key — merges rather than overwrites so
/// fields other modules own (name, email, gender, avatarPath, ...) are
/// preserved.
abstract class ResidencyLocalDataSource {
  ResidencyAddressModel getCachedAddress();
  Future<void> saveAddress(ResidencyAddressModel address);
}

class ResidencyLocalDataSourceImpl implements ResidencyLocalDataSource {
  final LocalStorageService _localStorage;

  ResidencyLocalDataSourceImpl({required LocalStorageService localStorage})
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
  ResidencyAddressModel getCachedAddress() {
    try {
      final json = _readRawMap();
      final residency = json['residency'] as Map<String, dynamic>?;
      if (residency == null) return const ResidencyAddressModel();
      return ResidencyAddressModel.fromJson(residency);
    } catch (e) {
      throw CacheException('Failed to read cached residency address: $e');
    }
  }

  @override
  Future<void> saveAddress(ResidencyAddressModel address) async {
    try {
      final merged = _readRawMap()..addAll({'residency': address.toJson()});
      await _localStorage.setCachedUserProfileJson(jsonEncode(merged));
    } catch (e) {
      throw CacheException('Failed to save residency address: $e');
    }
  }
}
