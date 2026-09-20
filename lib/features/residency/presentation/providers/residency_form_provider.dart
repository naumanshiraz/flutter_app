import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/residency/domain/entities/campus_option.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';
import 'package:pms_app/features/residency/presentation/providers/residency_di_providers.dart';

class ResidencyFormState {
  final bool isLoading;
  final bool isSaving;
  final ResidencyAddress address;
  final List<CampusOption> campusOptions;
  final String? errorMessage;

  const ResidencyFormState({
    this.isLoading = true,
    this.isSaving = false,
    this.address = const ResidencyAddress(),
    this.campusOptions = const [],
    this.errorMessage,
  });

  ResidencyFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    ResidencyAddress? address,
    List<CampusOption>? campusOptions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResidencyFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      address: address ?? this.address,
      campusOptions: campusOptions ?? this.campusOptions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

const ResidencyAddress _kDefaultAddress = ResidencyAddress(
  country: 'Mongolia',
  city: 'Ulaanbaatar',
);

class ResidencyFormNotifier extends StateNotifier<ResidencyFormState> {
  final Ref _ref;

  ResidencyFormNotifier(this._ref) : super(const ResidencyFormState()) {
    _load();
  }

  Future<void> _load() async {
    final getCached = _ref.read(getCachedResidencyAddressUseCaseProvider);
    final getCampuses = _ref.read(getCampusOptionsUseCaseProvider);

    final cachedResult = await getCached();
    final campusesResult = await getCampuses();

    final address = cachedResult.when(
      onSuccess: (cached) => cached.country != null ? cached : _kDefaultAddress,
      onFailure: (_) => _kDefaultAddress,
    );

    campusesResult.when(
      onSuccess: (campuses) {
        state = state.copyWith(isLoading: false, address: address, campusOptions: campuses);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, address: address, errorMessage: failure.message);
      },
    );
  }

  List<String> countryOptions() => _ref.read(residencyGeoDataSourceProvider).countries();

  List<String> cityOptions() {
    final country = state.address.country;
    if (country == null) return const [];
    return _ref.read(residencyGeoDataSourceProvider).citiesFor(country);
  }

  void selectCampus(CampusOption option) {
    state = state.copyWith(
      address: state.address.copyWith(campusId: option.id, campusName: option.name),
      clearError: true,
    );
  }

  void selectCountry(String value) {
    state = state.copyWith(
      address: state.address.copyWith(country: value).clearBelow(ResidencyLevel.country),
      clearError: true,
    );
  }

  void selectCity(String value) {
    state = state.copyWith(address: state.address.copyWith(city: value), clearError: true);
  }

  Future<bool> save() async {
    if (!state.address.isComplete) {
      state = state.copyWith(errorMessage: 'Please complete every field.');
      return false;
    }
    state = state.copyWith(isSaving: true, clearError: true);

    final useCase = _ref.read(saveResidencyAddressUseCaseProvider);
    final result = await useCase(state.address);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(isSaving: false);
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isSaving: false, errorMessage: failure.message);
        return false;
      },
    );
  }
}

final residencyFormProvider =
    StateNotifierProvider.autoDispose<ResidencyFormNotifier, ResidencyFormState>(
  (ref) => ResidencyFormNotifier(ref),
);
