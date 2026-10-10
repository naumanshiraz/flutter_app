import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/family_members/domain/entities/invitation.dart';
import 'package:pms_app/features/family_members/presentation/providers/family_members_di_providers.dart';

class InvitationsState {
  final bool isLoading;
  final bool isSubmitting;
  final List<Invitation> invitations;
  final String? error;

  const InvitationsState({
    this.isLoading = true,
    this.isSubmitting = false,
    this.invitations = const [],
    this.error,
  });

  InvitationsState copyWith({bool? isSubmitting, List<Invitation>? invitations}) {
    return InvitationsState(
      isLoading: isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      invitations: invitations ?? this.invitations,
      error: error,
    );
  }
}

class InvitationsNotifier extends StateNotifier<InvitationsState> {
  final Ref _ref;
  final String _householdId;

  InvitationsNotifier(this._ref, this._householdId) : super(const InvitationsState()) {
    refresh();
  }

  Future<void> refresh() async {
    if (_householdId.isEmpty) {
      state = const InvitationsState(isLoading: false);
      return;
    }
    state = const InvitationsState();
    final result = await _ref.read(getHouseholdInvitationsUseCaseProvider)(_householdId);
    result.when(
      onSuccess: (list) => state = InvitationsState(isLoading: false, invitations: list),
      onFailure: (f) => state = InvitationsState(isLoading: false, error: f.message),
    );
  }

  Future<String?> deleteInvitation(String invitationId) async {
    final result = await _ref.read(deleteInvitationUseCaseProvider)(invitationId);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          invitations: state.invitations.where((i) => i.id != invitationId).toList(),
        );
        return null;
      },
      onFailure: (f) => f.message,
    );
  }

  Future<String?> createInvitation({
    required String identifier,
    required String relation,
    bool canUseDevices = false,
  }) async {
    if (_householdId.isEmpty) return 'No household selected.';
    state = state.copyWith(isSubmitting: true);
    final result = await _ref.read(createHouseholdInvitationUseCaseProvider)(
      householdId: _householdId,
      identifier: identifier,
      relation: relation,
      canUseDevices: canUseDevices,
    );
    final error = result.when(onSuccess: (_) => null, onFailure: (f) => f.message);
    if (error != null) {
      state = state.copyWith(isSubmitting: false);
      return error;
    }
    final listResult = await _ref.read(getHouseholdInvitationsUseCaseProvider)(_householdId);
    listResult.when(
      onSuccess: (list) => state = state.copyWith(isSubmitting: false, invitations: list),
      onFailure: (_) => state = state.copyWith(isSubmitting: false),
    );
    return null;
  }
}

final invitationsProvider =
    StateNotifierProvider.autoDispose.family<InvitationsNotifier, InvitationsState, String>(
  (ref, householdId) => InvitationsNotifier(ref, householdId),
);
