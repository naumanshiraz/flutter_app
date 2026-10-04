import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/domain/usecases/visitor_usecases.dart';
import 'package:pms_app/features/main_home/presentation/providers/visitor_di_providers.dart';

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

/// Visitor schedules for a single household (identified by [_householdId]),
/// so switching households (prev/next arrows) shows that household's own
/// schedule.
class VisitorNotifier extends StateNotifier<VisitorState> {
  final GetVisitorSchedulesUseCase _getUseCase;
  final AddOrUpdateVisitorScheduleUseCase _addUpdateUseCase;
  final DeleteVisitorScheduleUseCase _deleteUseCase;
  final String _householdId;

  VisitorNotifier(this._getUseCase, this._addUpdateUseCase, this._deleteUseCase, this._householdId)
      : super(const VisitorState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _getUseCase(householdId: _householdId);
      result.when(
        onSuccess: (schedules) {
          // Newest first, so a just-created schedule is the one shown/acted on.
          final sorted = [...schedules]..sort((a, b) {
            if (a.createdAt == null || b.createdAt == null) return 0;
            return b.createdAt!.compareTo(a.createdAt!);
          });
          state = state.copyWith(isLoading: false, schedules: sorted);
        },
        onFailure: (f) {
          state = state.copyWith(isLoading: false, error: f.message);
        },
      );
    } catch (e) {
      // Safety net: see HouseholdNotifier._fetch for why this is needed.
      state = state.copyWith(isLoading: false, error: 'Something went wrong: $e');
    }
  }

  Future<void> refresh() => _fetch();

  Future<void> addOrUpdate(VisitorSchedule schedule) async {
    final tagged = schedule.copyWith(householdId: _householdId);
    final result = await _addUpdateUseCase(tagged);
    result.when(
      onSuccess: (_) => refresh(),
      onFailure: (f) => state = state.copyWith(error: f.message),
    );
  }

  Future<void> delete(String id) async {
    final result = await _deleteUseCase(householdId: _householdId, visitorId: id);
    result.when(
      onSuccess: (_) => refresh(),
      onFailure: (f) => state = state.copyWith(error: f.message),
    );
  }
}

final visitorNotifierProvider =
    StateNotifierProvider.autoDispose.family<VisitorNotifier, VisitorState, String>((ref, householdId) {
  return VisitorNotifier(
    ref.watch(getVisitorSchedulesUseCaseProvider),
    ref.watch(addOrUpdateVisitorScheduleUseCaseProvider),
    ref.watch(deleteVisitorScheduleUseCaseProvider),
    householdId,
  );
});
