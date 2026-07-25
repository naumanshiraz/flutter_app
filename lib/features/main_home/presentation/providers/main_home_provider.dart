import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';
import 'package:pms_app/features/main_home/domain/usecases/get_controls_usecase.dart';
import 'package:pms_app/features/main_home/presentation/providers/main_home_di_providers.dart';
import 'package:pms_app/core/error/failures.dart';

class MainHomeState {
  final bool isLoading;
  final List<Control> controls;
  final String? error;

  const MainHomeState({this.isLoading = true, this.controls = const [], this.error});

  MainHomeState copyWith({bool? isLoading, List<Control>? controls, String? error, bool clearError = false}) {
    return MainHomeState(
      isLoading: isLoading ?? this.isLoading,
      controls: controls ?? this.controls,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MainHomeNotifier extends StateNotifier<MainHomeState> {
  final GetControlsUseCase _getControlsUseCase;
  final Ref _ref;
  Timer? _debounce;

  MainHomeNotifier(this._ref, this._getControlsUseCase) : super(const MainHomeState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getControlsUseCase();
    result.when(
      onSuccess: (controls) {
        state = state.copyWith(isLoading: false, controls: controls);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
    );
  }

  Future<void> refresh() => _fetch();

  Future<void> toggle(String id) async {
    final repo = _ref.read(mainHomeRepositoryProvider);
    final idx = state.controls.indexWhere((c) => c.id == id);
    if (idx == -1) return;

    final current = state.controls[idx];
    final updated = current.copyWith(isOn: !current.isOn);
    final newList = List<Control>.from(state.controls);
    newList[idx] = updated;
    state = state.copyWith(controls: newList);

    final result = await repo.toggleControl(id, updated.isOn);
    result.when(
      onSuccess: (_) {
        // success: nothing else to do (persisted by repo)
      },
      onFailure: (failure) {
        // rollback on failure
        newList[idx] = current;
        state = state.copyWith(controls: newList, error: failure.message);
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final mainHomeNotifierProvider = StateNotifierProvider.autoDispose<MainHomeNotifier, MainHomeState>(
      (ref) => MainHomeNotifier(ref, ref.watch(getControlsUseCaseProvider)),
);