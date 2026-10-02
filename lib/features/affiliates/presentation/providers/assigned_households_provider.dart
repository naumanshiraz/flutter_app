import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_di_providers.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

class AssignedHouseholdsState {
  final bool isLoading;
  final List<Household> households;
  final String? error;

  const AssignedHouseholdsState({this.isLoading = true, this.households = const [], this.error});

  AssignedHouseholdsState copyWith({
    bool? isLoading,
    List<Household>? households,
    String? error,
    bool clearError = false,
  }) {
    return AssignedHouseholdsState(
      isLoading: isLoading ?? this.isLoading,
      households: households ?? this.households,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AssignedHouseholdsNotifier extends StateNotifier<AssignedHouseholdsState> {
  final Ref _ref;
  final String _affiliateId;

  AssignedHouseholdsNotifier(this._ref, this._affiliateId) : super(const AssignedHouseholdsState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _ref.read(getAssignedHouseholdsUseCaseProvider)(_affiliateId);
    result.when(
      onSuccess: (households) => state = state.copyWith(isLoading: false, households: households),
      onFailure: (f) => state = state.copyWith(isLoading: false, error: f.message),
    );
  }

  Future<void> refresh() => _load();

  /// Returns null on success, or an error message on failure.
  Future<String?> removeAccess(String householdId) async {
    final result = await _ref.read(removeHouseholdAccessUseCaseProvider)(
      affiliateId: _affiliateId,
      householdId: householdId,
    );
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(households: state.households.where((h) => h.id != householdId).toList());
        return null;
      },
      onFailure: (f) => f.message,
    );
  }
}

final assignedHouseholdsProvider = StateNotifierProvider.autoDispose
    .family<AssignedHouseholdsNotifier, AssignedHouseholdsState, String>(
  (ref, affiliateId) => AssignedHouseholdsNotifier(ref, affiliateId),
);
