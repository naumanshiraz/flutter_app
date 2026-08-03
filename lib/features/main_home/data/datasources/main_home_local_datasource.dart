import 'dart:async';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/main_home/data/models/control_model.dart';

abstract class MainHomeLocalDataSource {
  Future<List<ControlModel>> fetchControls();
  Future<void> persistToggle(String id, bool newState);
}

class MainHomeLocalDataSourceImpl implements MainHomeLocalDataSource {
  MainHomeLocalDataSourceImpl();

  @override
  Future<List<ControlModel>> fetchControls() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mocked local dataset (no backend needed)
      return const [
        ControlModel(
          id: 'main_entrance',
          title: 'Main entrance door',
          subtitle: 'Closed',
          iconName: 'door',
          isOn: false,
        ),
        ControlModel(
          id: 'north_gate',
          title: 'North campus gate',
          subtitle: 'Closed',
          iconName: 'gate',
          isOn: false,
        ),
        ControlModel(
          id: 'barrier',
          title: 'South-East entrance barrier',
          subtitle: 'Closed',
          iconName: 'barrier',
          isOn: false,
        ),
        ControlModel(
          id: 'elevator',
          title: 'Bring the lift to my floor',
          subtitle: 'Ready',
          iconName: 'elevator',
          isOn: false,
        ),
      ];
    } catch (e) {
      throw CacheException('Failed to read local controls: $e');
    }
  }

  @override
  Future<void> persistToggle(String id, bool newState) async {
    try {
      // In a real app you'd write to local storage here
      await Future.delayed(const Duration(milliseconds: 150));
    } catch (e) {
      throw CacheException('Failed to persist control toggle: $e');
    }
  }
}