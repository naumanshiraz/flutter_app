import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:pms_app/features/main_home/data/models/visitor_model.dart';
import 'package:pms_app/core/error/exceptions.dart';

abstract class VisitorLocalDataSource {
  Future<List<VisitorModel>> getSchedules();
  Future<void> addOrUpdateSchedule(VisitorModel model);
  Future<void> deleteSchedule(String id);
  Future<void> clearAll();
}

class VisitorLocalDataSourceImpl implements VisitorLocalDataSource {
  static const String _boxName = 'visitor_schedules_box';

  Future<Box> _openBox() async {
    // Hive must be initialized at app bootstrap (LocalStorageService.init)
    return Hive.openBox(_boxName);
  }

  @override
  Future<void> addOrUpdateSchedule(VisitorModel model) async {
    try {
      final box = await _openBox();
      // store as Map so reading is straightforward
      await box.put(model.id, model.toJson());
    } catch (e) {
      throw CacheException('Failed to save schedule: $e');
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      final box = await _openBox();
      await box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete schedule: $e');
    }
  }

  @override
  Future<List<VisitorModel>> getSchedules() async {
    try {
      final box = await _openBox();
      final List<VisitorModel> out = [];
      for (final val in box.values) {
        if (val == null) continue;
        if (val is Map) {
          out.add(VisitorModel.fromJson(Map<String, dynamic>.from(val)));
        } else if (val is String) {
          // support string-serialized JSON if any old data exists
          try {
            final parsed = jsonDecode(val) as Map<String, dynamic>;
            out.add(VisitorModel.fromJson(parsed));
          } catch (_) {
            // ignore malformed entry
          }
        } else if (val is Map<String, dynamic>) {
          out.add(VisitorModel.fromJson(val));
        }
      }
      return out;
    } catch (e) {
      throw CacheException('Failed to read schedules: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      final box = await _openBox();
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear schedules: $e');
    }
  }
}