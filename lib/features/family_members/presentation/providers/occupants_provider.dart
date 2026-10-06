import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/family_members/domain/entities/occupant.dart';
import 'package:pms_app/features/family_members/presentation/providers/family_members_di_providers.dart';

class OccupantsState {
  final bool isLoading;
  final List<Occupant> occupants;
  final String? error;

  const OccupantsState({this.isLoading = true, this.occupants = const [], this.error});

  List<Occupant> get familyMembers => occupants.where((o) => !o.isTenant).toList();
  List<Occupant> get tenants => occupants.where((o) => o.isTenant).toList();

  OccupantsState copyWith({
    bool? isLoading,
    List<Occupant>? occupants,
    String? error,
    bool clearError = false,
  }) {
    return OccupantsState(
      isLoading: isLoading ?? this.isLoading,
      occupants: occupants ?? this.occupants,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class OccupantsNotifier extends StateNotifier<OccupantsState> {
  final Ref _ref;
  final String _householdId;

  OccupantsNotifier(this._ref, this._householdId) : super(const OccupantsState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _ref.read(getHouseholdMembersUseCaseProvider)(_householdId);
    result.when(
      onSuccess: (occupants) => state = state.copyWith(isLoading: false, occupants: occupants),
      onFailure: (f) => state = state.copyWith(isLoading: false, error: f.message),
    );
  }

  Future<void> refresh() => _load();
}

final occupantsProvider = StateNotifierProvider.autoDispose.family<OccupantsNotifier, OccupantsState, String>(
  (ref, householdId) => OccupantsNotifier(ref, householdId),
);
