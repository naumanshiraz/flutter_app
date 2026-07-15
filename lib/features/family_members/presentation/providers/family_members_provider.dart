import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';
import 'package:pms_app/features/family_members/presentation/providers/family_members_di_providers.dart';

class FamilyMembersState {
  final bool isLoading;
  final bool isSubmittingDraft;
  final List<FamilyMember> members;
  final FamilyMember draft;
  final String? errorMessage;

  const FamilyMembersState({
    this.isLoading = true,
    this.isSubmittingDraft = false,
    this.members = const [],
    required this.draft,
    this.errorMessage,
  });

  FamilyMembersState copyWith({
    bool? isLoading,
    bool? isSubmittingDraft,
    List<FamilyMember>? members,
    FamilyMember? draft,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FamilyMembersState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingDraft: isSubmittingDraft ?? this.isSubmittingDraft,
      members: members ?? this.members,
      draft: draft ?? this.draft,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Backs the "Please identify your affiliates" screen (list + draft
/// add-form) *and* the Edit-affiliate screen — both read/write through
/// this one notifier so the list stays in sync, the same pattern used
/// for `editProfileProvider` powering both Edit Profile and Profile
/// Picture.
class FamilyMembersNotifier extends StateNotifier<FamilyMembersState> {
  final Ref _ref;
  static const _uuid = Uuid();

  FamilyMembersNotifier(this._ref) : super(FamilyMembersState(draft: FamilyMember(id: _uuid.v4()))) {
    _load();
  }

  Future<void> _load() async {
    final useCase = _ref.read(getFamilyMembersUseCaseProvider);
    final result = await useCase();
    result.when(
      onSuccess: (members) {
        state = state.copyWith(isLoading: false, members: members);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  void updateDraft({
    String? name,
    String? email,
    String? phone,
    String? relationship,
    int? birthYear,
    String? gender,
  }) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        name: name,
        email: email,
        phone: phone,
        relationship: relationship,
        birthYear: birthYear,
        gender: gender,
      ),
      clearError: true,
    );
  }

  /// Validates and persists the current draft, then resets the draft
  /// (with a fresh id) so the form is ready for the next affiliate.
  Future<bool> addDraftAsMember() async {
    if (!state.draft.isValid) {
      state = state.copyWith(errorMessage: 'Please complete every field before adding.');
      return false;
    }
    state = state.copyWith(isSubmittingDraft: true, clearError: true);

    final useCase = _ref.read(addFamilyMemberUseCaseProvider);
    final result = await useCase(state.draft);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isSubmittingDraft: false,
          members: [...state.members, state.draft],
          draft: FamilyMember(id: _uuid.v4()),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isSubmittingDraft: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> updateMember(FamilyMember updated) async {
    final useCase = _ref.read(updateFamilyMemberUseCaseProvider);
    final result = await useCase(updated);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          members: state.members.map((m) => m.id == updated.id ? updated : m).toList(),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteMember(String id) async {
    final useCase = _ref.read(deleteFamilyMemberUseCaseProvider);
    final result = await useCase(id);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(members: state.members.where((m) => m.id != id).toList());
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }
}

final familyMembersProvider =
    StateNotifierProvider.autoDispose<FamilyMembersNotifier, FamilyMembersState>(
  (ref) => FamilyMembersNotifier(ref),
);
