import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/presentation/providers/pets_di_providers.dart';

class PetsState {
  final bool isLoading;
  final bool isSubmittingDraft;
  final List<Pet> pets;
  final Pet draft;
  final String? errorMessage;

  const PetsState({
    this.isLoading = true,
    this.isSubmittingDraft = false,
    this.pets = const [],
    required this.draft,
    this.errorMessage,
  });

  PetsState copyWith({
    bool? isLoading,
    bool? isSubmittingDraft,
    List<Pet>? pets,
    Pet? draft,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PetsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingDraft: isSubmittingDraft ?? this.isSubmittingDraft,
      pets: pets ?? this.pets,
      draft: draft ?? this.draft,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class PetsNotifier extends StateNotifier<PetsState> {
  final Ref _ref;
  final String _householdId;
  static const _uuid = Uuid();

  PetsNotifier(this._ref, this._householdId) : super(PetsState(draft: Pet(id: _uuid.v4()))) {
    _load();
  }

  Future<void> _load() async {
    if (_householdId.isEmpty) {
      state = state.copyWith(isLoading: false, errorMessage: 'No household selected.');
      return;
    }
    final useCase = _ref.read(getPetsUseCaseProvider);
    final result = await useCase(_householdId);
    result.when(
      onSuccess: (pets) => state = state.copyWith(isLoading: false, pets: pets),
      onFailure: (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  void updateDraft({String? species, String? breed, String? numberOfPets}) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        species: species,
        breed: breed,
        numberOfPets: numberOfPets,
      ),
      clearError: true,
    );
  }

  Future<bool> addDraftAsPet() async {
    if (!state.draft.isValid) {
      state = state.copyWith(errorMessage: 'Please complete every field before adding.');
      return false;
    }
    state = state.copyWith(isSubmittingDraft: true, clearError: true);

    final useCase = _ref.read(addPetUseCaseProvider);
    final result = await useCase(_householdId, state.draft);

    final ok = result.when(
      onSuccess: (_) => true,
      onFailure: (failure) {
        state = state.copyWith(isSubmittingDraft: false, errorMessage: failure.message);
        return false;
      },
    );
    if (!ok) return false;

    state = state.copyWith(isSubmittingDraft: false, draft: Pet(id: _uuid.v4()));
    final listResult = await _ref.read(getPetsUseCaseProvider)(_householdId);
    listResult.when(
      onSuccess: (list) => state = state.copyWith(pets: list),
      onFailure: (_) {},
    );
    return true;
  }

  Future<bool> updatePet(Pet updated) async {
    final useCase = _ref.read(updatePetUseCaseProvider);
    final result = await useCase(_householdId, updated);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          pets: state.pets.map((p) => p.id == updated.id ? updated : p).toList(),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deletePet(String id) async {
    final useCase = _ref.read(deletePetUseCaseProvider);
    final result = await useCase(_householdId, id);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(pets: state.pets.where((p) => p.id != id).toList());
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }
}

final petsProvider = StateNotifierProvider.autoDispose.family<PetsNotifier, PetsState, String>(
  (ref, householdId) => PetsNotifier(ref, householdId),
);
