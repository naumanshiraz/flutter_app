import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/vehicles/data/models/vehicle_model.dart';

/// Reads/writes the vehicles list into the same cached-profile JSON
/// blob every other profile-adjacent module uses
/// (`LocalStorageService.cachedUserProfileJson`), under a nested
/// `vehicles` array — merges rather than overwrites so fields other
/// modules own are preserved.
abstract class VehiclesLocalDataSource {
  List<VehicleModel> getVehicles();
  Future<void> saveVehicles(List<VehicleModel> vehicles);
}

class VehiclesLocalDataSourceImpl implements VehiclesLocalDataSource {
  final LocalStorageService _localStorage;

  VehiclesLocalDataSourceImpl({required LocalStorageService localStorage})
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
  List<VehicleModel> getVehicles() {
    try {
      final json = _readRawMap();
      final rawList = json['vehicles'] as List<dynamic>?;
      if (rawList == null) return [];
      return rawList.map((e) => VehicleModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException('Failed to read cached vehicles: $e');
    }
  }

  @override
  Future<void> saveVehicles(List<VehicleModel> vehicles) async {
    try {
      final merged = _readRawMap()
        ..addAll({'vehicles': vehicles.map((v) => v.toJson()).toList()});
      await _localStorage.setCachedUserProfileJson(jsonEncode(merged));
    } catch (e) {
      throw CacheException('Failed to save vehicles: $e');
    }
  }
}
