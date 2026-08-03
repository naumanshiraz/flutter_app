import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/features/family_members/data/models/family_member_model.dart';

abstract class FamilyMembersLocalDataSource {
  List<FamilyMemberModel> getMembers();
  Future<void> saveMembers(List<FamilyMemberModel> members);
}

class FamilyMembersLocalDataSourceImpl implements FamilyMembersLocalDataSource {
  final LocalStorageService _localStorage;

  FamilyMembersLocalDataSourceImpl({required LocalStorageService localStorage})
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
  List<FamilyMemberModel> getMembers() {
    try {
      final json = _readRawMap();
      final rawList = json['familyMembers'] as List<dynamic>?;
      if (rawList == null) return [];
      return rawList
          .map((e) => FamilyMemberModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to read cached family members: $e');
    }
  }

  @override
  Future<void> saveMembers(List<FamilyMemberModel> members) async {
    try {
      final merged = _readRawMap()
        ..addAll({'familyMembers': members.map((m) => m.toJson()).toList()});
      await _localStorage.setCachedUserProfileJson(jsonEncode(merged));
    } catch (e) {
      throw CacheException('Failed to save family members: $e');
    }
  }
}
