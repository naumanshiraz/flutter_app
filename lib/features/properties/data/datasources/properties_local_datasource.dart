import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/properties/data/models/property_model.dart';

/// Reads/writes the properties list into the same cached-profile JSON
/// blob every other profile-adjacent module uses
/// (`LocalStorageService.cachedUserProfileJson`), under a nested
/// `properties` array — merges rather than overwrites so fields other
/// modules own are preserved.
abstract class PropertiesLocalDataSource {
  List<PropertyModel> getProperties();
  Future<void> saveProperties(List<PropertyModel> properties);
}

class PropertiesLocalDataSourceImpl implements PropertiesLocalDataSource {
  final LocalStorageService _localStorage;

  PropertiesLocalDataSourceImpl({required LocalStorageService localStorage})
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
  List<PropertyModel> getProperties() {
    try {
      final json = _readRawMap();
      final rawList = json['properties'] as List<dynamic>?;
      if (rawList == null) return [];
      return rawList.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException('Failed to read cached properties: $e');
    }
  }

  @override
  Future<void> saveProperties(List<PropertyModel> properties) async {
    try {
      final merged = _readRawMap()
        ..addAll({'properties': properties.map((p) => p.toJson()).toList()});
      await _localStorage.setCachedUserProfileJson(jsonEncode(merged));
    } catch (e) {
      throw CacheException('Failed to save properties: $e');
    }
  }
}
