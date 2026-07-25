import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/domain/usecases/visitor_usecases.dart';
import 'package:pms_app/features/main_home/presentation/providers/main_home_di_providers.dart';
import 'package:pms_app/features/main_home/data/datasources/visitor_local_datasource.dart';
import 'package:pms_app/features/main_home/data/repositories/visitor_repository_impl.dart';

class VisitorState {
  final bool isLoading;
  final List<VisitorSchedule> schedules;
  final String? error;

  const VisitorState({this.isLoading = true, this.schedules = const [], this.error});

  VisitorState copyWith({bool? isLoading, List<VisitorSchedule>? schedules, String? error, bool clearError = false}) {
    return VisitorState(
      isLoading: isLoading ?? this.isLoading,
      schedules: schedules ?? this.schedules,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class VisitorNotifier extends StateNotifier<VisitorState> {
  final Ref _ref;
  final GetVisitorSchedulesUseCase _getUseCase;
  final AddOrUpdateVisitorScheduleUseCase _addUpdateUseCase;
  final DeleteVisitorScheduleUseCase _deleteUseCase;

  VisitorNotifier(this._ref, this._getUseCase, this._addUpdateUseCase, this._deleteUseCase) : super(const VisitorState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getUseCase();
    result.when(
      onSuccess: (schedules) {
        // DO NOT auto-create a placeholder — use dynamic (empty) state
        state = state.copyWith(isLoading: false, schedules: schedules);
      },
      onFailure: (f) {
        state = state.copyWith(isLoading: false, error: f.message);
      },
    );
  }

  Future<void> refresh() => _fetch();

  Future<void> addOrUpdate(VisitorSchedule schedule) async {
    final result = await _addUpdateUseCase(schedule);
    result.when(
      onSuccess: (_) => refresh(),
      onFailure: (f) => state = state.copyWith(error: f.message),
    );
  }

  Future<void> delete(String id) async {
    final result = await _deleteUseCase(id);
    result.when(
      onSuccess: (_) => refresh(),
      onFailure: (f) => state = state.copyWith(error: f.message),
    );
  }
}

final visitorNotifierProvider = StateNotifierProvider.autoDispose<VisitorNotifier, VisitorState>((ref) {
  // Wire via DI providers if you have them; otherwise create local instances
  final local = VisitorLocalDataSourceImpl();
  final repo = VisitorRepositoryImpl(local: local);
  final getUse = GetVisitorSchedulesUseCase(repo);
  final addUpd = AddOrUpdateVisitorScheduleUseCase(repo);
  final del = DeleteVisitorScheduleUseCase(repo);
  return VisitorNotifier(ref, getUse, addUpd, del);
});