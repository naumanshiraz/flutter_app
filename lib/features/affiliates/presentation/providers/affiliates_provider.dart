import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_di_providers.dart';
import 'package:pms_app/features/affiliates/presentation/utils/affiliate_validators.dart';

class AffiliatesState {
  final bool isLoading;
  final bool isSubmittingDraft;
  final List<Affiliate> affiliates;
  final String? draftRelationship;
  final String? errorMessage;

  const AffiliatesState({
    this.isLoading = true,
    this.isSubmittingDraft = false,
    this.affiliates = const [],
    this.draftRelationship,
    this.errorMessage,
  });

  List<Affiliate> get familyMembers => affiliates.where((a) => !a.isTenant).toList();
  List<Affiliate> get tenants => affiliates.where((a) => a.isTenant).toList();

  AffiliatesState copyWith({
    bool? isLoading,
    bool? isSubmittingDraft,
    List<Affiliate>? affiliates,
    String? draftRelationship,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AffiliatesState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingDraft: isSubmittingDraft ?? this.isSubmittingDraft,
      affiliates: affiliates ?? this.affiliates,
      draftRelationship: draftRelationship ?? this.draftRelationship,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AffiliatesNotifier extends StateNotifier<AffiliatesState> {
  final Ref _ref;
  final String? _householdId;
  static const _uuid = Uuid();

  AffiliatesNotifier(this._ref, this._householdId) : super(const AffiliatesState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = _ref.read(getAffiliatesUseCaseProvider);
    final result = await useCase(householdId: _householdId);
    result.when(
      onSuccess: (affiliates) => state = state.copyWith(isLoading: false, affiliates: affiliates),
      onFailure: (f) => state = state.copyWith(isLoading: false, errorMessage: f.message),
    );
  }

  Future<void> refresh() => _load();

  void updateDraftRelationship(String relationship) {
    state = state.copyWith(draftRelationship: relationship, clearError: true);
  }

  Future<String?> addAffiliate({required String name, required String contact}) async {
    final error = AffiliateValidators.validateDraft(
      name: name,
      contact: contact,
      relationship: state.draftRelationship,
    );
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return error;
    }

    state = state.copyWith(isSubmittingDraft: true, clearError: true);
    final isEmail = contact.contains('@');
    final draft = Affiliate(
      id: _uuid.v4(),
      householdId: _householdId,
      name: name.trim(),
      email: isEmail ? contact.trim() : '',
      phone: isEmail ? '' : contact.trim(),
      relationship: state.draftRelationship,
      status: 'Active',
    );

    final useCase = _ref.read(addOrUpdateAffiliateUseCaseProvider);
    final result = await useCase(draft);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isSubmittingDraft: false,
          affiliates: [...state.affiliates, draft],
          draftRelationship: null,
        );
        return null;
      },
      onFailure: (f) {
        state = state.copyWith(isSubmittingDraft: false, errorMessage: f.message);
        return f.message;
      },
    );
  }

  Future<bool> updateAffiliate(Affiliate updated) async {
    if (!AffiliateValidators.isValid(updated)) {
      state = state.copyWith(errorMessage: 'Please complete every field before saving.');
      return false;
    }
    final useCase = _ref.read(addOrUpdateAffiliateUseCaseProvider);
    final result = await useCase(updated);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          affiliates: state.affiliates.map((a) => a.id == updated.id ? updated : a).toList(),
        );
        return true;
      },
      onFailure: (f) {
        state = state.copyWith(errorMessage: f.message);
        return false;
      },
    );
  }

  Future<bool> deleteAffiliate(String id) async {
    final useCase = _ref.read(deleteAffiliateUseCaseProvider);
    final result = await useCase(id);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(affiliates: state.affiliates.where((a) => a.id != id).toList());
        return true;
      },
      onFailure: (f) {
        state = state.copyWith(errorMessage: f.message);
        return false;
      },
    );
  }
}

final affiliatesProvider =
    StateNotifierProvider.autoDispose.family<AffiliatesNotifier, AffiliatesState, String?>(
  (ref, householdId) => AffiliatesNotifier(ref, householdId),
);
