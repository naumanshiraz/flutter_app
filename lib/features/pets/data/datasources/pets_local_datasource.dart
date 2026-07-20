import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/pets/data/models/pet_model.dart';

abstract class PetsLocalDataSource {
  List<PetModel> getPets();
  Future<void> savePets(List<PetModel> pets);
}

class PetsLocalDataSourceImpl implements PetsLocalDataSource {
  final LocalStorageService _localStorage;

  PetsLocalDataSourceImpl({required LocalStorageService localStorage})
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
  List<PetModel> getPets() {
    try {
      final json = _readRawMap();
      final rawList = json['pets'] as List<dynamic>?;
      if (rawList == null) return [];
      return rawList.map((e) => PetModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException('Failed to read cached pets: $e');
    }
  }

  @override
  Future<void> savePets(List<PetModel> pets) async {
    try {
      final merged = _readRawMap()..addAll({'pets': pets.map((p) => p.toJson()).toList()});
      await _localStorage.setCachedUserProfileJson(jsonEncode(merged));
    } catch (e) {
      throw CacheException('Failed to save pets: $e');
    }
  }
}
