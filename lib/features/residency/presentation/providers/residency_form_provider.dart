import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';
import 'package:pms_app/features/residency/presentation/providers/residency_di_providers.dart';

class ResidencyFormState {
  final bool isLoading;
  final bool isSaving;
  final ResidencyAddress address;
  final String? errorMessage;

  const ResidencyFormState({
    this.isLoading = true,
    this.isSaving = false,
    this.address = const ResidencyAddress(),
    this.errorMessage,
  });

  ResidencyFormState copyWith({
    bool? isLoading,
    bool? isSaving,
    ResidencyAddress? address,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResidencyFormState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      address: address ?? this.address,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Defaults shown on first visit — matches the design's pre-filled
/// example (Mongolia / Ulaanbaatar / Khan Uul / 15th khoroo / Gerlug
/// Vista) rather than starting blank, consistent with the screenshot.
const ResidencyAddress _kDefaultAddress = ResidencyAddress(
  country: 'Mongolia',
  city: 'Ulaanbaatar',
  district: 'Khan Uul',
  khoroo: '15th khoroo',
  residence: 'Gerlug Vista',
);

class ResidencyFormNotifier extends StateNotifier<ResidencyFormState> {
  final Ref _ref;

  ResidencyFormNotifier(this._ref) : super(const ResidencyFormState()) {
    _load();
  }

  Future<void> _load() async {
    final useCase = _ref.read(getCachedResidencyAddressUseCaseProvider);
    final result = await useCase();
    result.when(
      onSuccess: (cached) {
        // Fall back to the design's defaults if nothing's been saved yet.
        final address = cached.isComplete ? cached : _kDefaultAddress;
        state = state.copyWith(isLoading: false, address: address);
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          address: _kDefaultAddress,
          errorMessage: failure.message,
        );
      },
    );
  }

  List<String> countryOptions() => _ref.read(residencyGeoDataSourceProvider).countries();

  List<String> cityOptions() {
    final country = state.address.country;
    if (country == null) return const [];
    return _ref.read(residencyGeoDataSourceProvider).citiesFor(country);
  }

  List<String> districtOptions() {
    final city = state.address.city;
    if (city == null) return const [];
    return _ref.read(residencyGeoDataSourceProvider).districtsFor(city);
  }

  List<String> khorooOptions() {
    final district = state.address.district;
    if (district == null) return const [];
    return _ref.read(residencyGeoDataSourceProvider).khoroosFor(district);
  }

  List<String> residenceOptions() {
    final khoroo = state.address.khoroo;
    if (khoroo == null) return const [];
    return _ref.read(residencyGeoDataSourceProvider).residencesFor(khoroo);
  }

  void selectCountry(String value) {
    state = state.copyWith(
      address: state.address.copyWith(country: value).clearBelow(ResidencyLevel.country),
      clearError: true,
    );
  }

  void selectCity(String value) {
    state = state.copyWith(
      address: state.address.copyWith(city: value).clearBelow(ResidencyLevel.city),
      clearError: true,
    );
  }

  void selectDistrict(String value) {
    state = state.copyWith(
      address: state.address.copyWith(district: value).clearBelow(ResidencyLevel.district),
      clearError: true,
    );
  }

  void selectKhoroo(String value) {
    state = state.copyWith(
      address: state.address.copyWith(khoroo: value).clearBelow(ResidencyLevel.khoroo),
      clearError: true,
    );
  }

  void selectResidence(String value) {
    state = state.copyWith(address: state.address.copyWith(residence: value), clearError: true);
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
