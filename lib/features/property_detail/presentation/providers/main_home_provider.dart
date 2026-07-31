import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';
import 'package:pms_app/features/main_home/domain/usecases/get_controls_usecase.dart';
import 'package:pms_app/features/main_home/domain/usecases/toggle_control_usecase.dart';
import 'package:pms_app/features/main_home/presentation/providers/main_home_di_providers.dart';

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
  final ToggleControlUseCase _toggleControlUseCase;
  final String? _propertyId;

  MainHomeNotifier(this._getControlsUseCase, this._toggleControlUseCase, this._propertyId)
      : super(const MainHomeState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _getControlsUseCase(propertyId: _propertyId);
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
    final idx = state.controls.indexWhere((c) => c.id == id);
    if (idx == -1) return;

    final current = state.controls[idx];
    final updated = current.copyWith(isOn: !current.isOn);
    final optimisticList = List<Control>.from(state.controls)..[idx] = updated;
    state = state.copyWith(controls: optimisticList);

    final result = await _toggleControlUseCase(id, updated.isOn);
    result.when(
      onSuccess: (_) {
        // success: nothing else to do (persisted by repo)
      },
      onFailure: (failure) {
        // rollback on failure using a fresh list, not the optimistic one
        final rolledBackList = List<Control>.from(state.controls)..[idx] = current;
        state = state.copyWith(controls: rolledBackList, error: failure.message);
      },
    );
  }
}

/// Keyed by the property id tapped on Home (nullable for direct entry
/// with no property selected yet).
final mainHomeNotifierProvider =
    StateNotifierProvider.autoDispose.family<MainHomeNotifier, MainHomeState, String?>(
  (ref, propertyId) => MainHomeNotifier(
    ref.watch(getControlsUseCaseProvider),
    ref.watch(toggleControlUseCaseProvider),
    propertyId,
  ),
);