import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/presentation/providers/properties_di_providers.dart';
import 'package:pms_app/features/residency/presentation/providers/residency_di_providers.dart';

class PropertiesState {
  final bool isLoading;
  final bool isSubmittingDraft;
  final List<Property> properties;
  final Property draft;
  final String? errorMessage;

  /// The Residence name and "District, City" string saved during the
  /// Residency Identification step — shown on each summary card as
  /// "Residency" / "Place", matching the design.
  final String residencyName;
  final String place;

  const PropertiesState({
    this.isLoading = true,
    this.isSubmittingDraft = false,
    this.properties = const [],
    required this.draft,
    this.errorMessage,
    this.residencyName = '',
    this.place = '',
  });

  PropertiesState copyWith({
    bool? isLoading,
    bool? isSubmittingDraft,
    List<Property>? properties,
    Property? draft,
    String? errorMessage,
    bool clearError = false,
    String? residencyName,
    String? place,
  }) {
    return PropertiesState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingDraft: isSubmittingDraft ?? this.isSubmittingDraft,
      properties: properties ?? this.properties,
      draft: draft ?? this.draft,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      residencyName: residencyName ?? this.residencyName,
      place: place ?? this.place,
    );
  }
}

/// Backs the "Please specify your property" screen (list + draft
/// add-form) *and* the Edit-property screen — same shared-notifier
/// pattern as `familyMembersProvider`.
class PropertiesNotifier extends StateNotifier<PropertiesState> {
  final Ref _ref;
  static const _uuid = Uuid();

  PropertiesNotifier(this._ref) : super(PropertiesState(draft: Property(id: _uuid.v4()))) {
    _load();
  }

  Future<void> _load() async {
    final propertiesUseCase = _ref.read(getPropertiesUseCaseProvider);
    final residencyUseCase = _ref.read(getCachedResidencyAddressUseCaseProvider);

    final propertiesResult = await propertiesUseCase();
    final residencyResult = await residencyUseCase();

    final residencyName = residencyResult.when(
      onSuccess: (address) => address.residence ?? '',
      onFailure: (_) => '',
    );
    final place = residencyResult.when(
      onSuccess: (address) {
        final parts = [address.khoroo, address.district, address.city]
            .where((p) => p != null && p.isNotEmpty)
            .toList();
        return parts.join(', ');
      },
      onFailure: (_) => '',
    );

    propertiesResult.when(
      onSuccess: (properties) {
        state = state.copyWith(
          isLoading: false,
          properties: properties,
          residencyName: residencyName,
          place: place,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          residencyName: residencyName,
          place: place,
        );
      },
    );
  }

  void updateDraft({String? suite, String? floor, String? type, String? building}) {
    state = state.copyWith(
      draft: state.draft.copyWith(suite: suite, floor: floor, type: type, building: building),
      clearError: true,
    );
  }

  /// Validates and persists the current draft, then resets the draft
  /// (with a fresh id) so the form is ready for the next property.
  Future<bool> addDraftAsProperty() async {
    if (!state.draft.isValid) {
      state = state.copyWith(errorMessage: 'Please complete every field before adding.');
      return false;
    }
    state = state.copyWith(isSubmittingDraft: true, clearError: true);

    final useCase = _ref.read(addPropertyUseCaseProvider);
    final result = await useCase(state.draft);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isSubmittingDraft: false,
          properties: [...state.properties, state.draft],
          draft: Property(id: _uuid.v4()),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isSubmittingDraft: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> updateProperty(Property updated) async {
    final useCase = _ref.read(updatePropertyUseCaseProvider);
    final result = await useCase(updated);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          properties: state.properties.map((p) => p.id == updated.id ? updated : p).toList(),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteProperty(String id) async {
    final useCase = _ref.read(deletePropertyUseCaseProvider);
    final result = await useCase(id);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(properties: state.properties.where((p) => p.id != id).toList());
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }
}

final propertiesProvider = StateNotifierProvider.autoDispose<PropertiesNotifier, PropertiesState>(
  (ref) => PropertiesNotifier(ref),
);
