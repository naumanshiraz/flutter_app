import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';
import 'package:pms_app/features/main_home/presentation/providers/household_di_providers.dart';

class HouseholdState {
  final bool isLoading;
  final List<Household> households;
  final int currentIndex;
  final String? error;

  const HouseholdState({
    this.isLoading = true,
    this.households = const [],
    this.currentIndex = 0,
    this.error,
  });

  Household? get current => households.isEmpty ? null : households[currentIndex];
  int get total => households.length;

  HouseholdState copyWith({
    bool? isLoading,
    List<Household>? households,
    int? currentIndex,
    String? error,
    bool clearError = false,
  }) {
    return HouseholdState(
      isLoading: isLoading ?? this.isLoading,
      households: households ?? this.households,
      currentIndex: currentIndex ?? this.currentIndex,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class HouseholdNotifier extends StateNotifier<HouseholdState> {
  final Ref _ref;
  final String _campusId;

  HouseholdNotifier(this._ref, this._campusId) : super(const HouseholdState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final getHouseholds = _ref.read(getHouseholdsUseCaseProvider);
    final result = await getHouseholds(campusId: _campusId);
    result.when(
      onSuccess: (households) {
        state = state.copyWith(isLoading: false, households: households, currentIndex: 0, clearError: true);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
    );
  }

  Future<void> refresh() => _fetch();

  void next() {
    if (state.households.isEmpty) return;
    final nextIndex = (state.currentIndex + 1) % state.households.length;
    state = state.copyWith(currentIndex: nextIndex);
  }

  void previous() {
    if (state.households.isEmpty) return;
    final prevIndex = (state.currentIndex - 1 + state.households.length) % state.households.length;
    state = state.copyWith(currentIndex: prevIndex);
  }
}

final householdNotifierProvider =
    StateNotifierProvider.autoDispose.family<HouseholdNotifier, HouseholdState, String>(
  (ref, campusId) => HouseholdNotifier(ref, campusId),
);
