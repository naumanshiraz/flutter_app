import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/domain/entities/residency_request.dart';
import 'package:pms_app/features/properties/presentation/providers/properties_di_providers.dart';
import 'package:pms_app/features/residency/presentation/providers/residency_di_providers.dart';

class PropertiesState {
  final bool isLoading;
  final bool isSubmittingClaim;
  final List<Property> properties;
  final List<ResidencyRequest> requests;
  final List<AvailableSuite> suites;
  final AvailableSuite? selectedSuite;
  final String? errorMessage;
  final String residencyName;
  final String place;

  const PropertiesState({
    this.isLoading = true,
    this.isSubmittingClaim = false,
    this.properties = const [],
    this.requests = const [],
    this.suites = const [],
    this.selectedSuite,
    this.errorMessage,
    this.residencyName = '',
    this.place = '',
  });

  PropertiesState copyWith({
    bool? isLoading,
    bool? isSubmittingClaim,
    List<Property>? properties,
    List<ResidencyRequest>? requests,
    List<AvailableSuite>? suites,
    AvailableSuite? selectedSuite,
    bool clearSelection = false,
    String? errorMessage,
    bool clearError = false,
    String? residencyName,
    String? place,
  }) {
    return PropertiesState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingClaim: isSubmittingClaim ?? this.isSubmittingClaim,
      properties: properties ?? this.properties,
      requests: requests ?? this.requests,
      suites: suites ?? this.suites,
      selectedSuite: clearSelection ? null : (selectedSuite ?? this.selectedSuite),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      residencyName: residencyName ?? this.residencyName,
      place: place ?? this.place,
    );
  }
}

class PropertiesNotifier extends StateNotifier<PropertiesState> {
  final Ref _ref;
  String? _campusId;

  PropertiesNotifier(this._ref) : super(const PropertiesState()) {
    _load();
  }

  Future<void> _load() async {
    final residencyResult = await _ref.read(getCachedResidencyAddressUseCaseProvider)();
    final residencyName = residencyResult.when(
      onSuccess: (address) => address.campusName ?? '',
      onFailure: (_) => '',
    );
    final place = residencyResult.when(
      onSuccess: (address) => [address.city, address.country].where((p) => p != null && p.isNotEmpty).join(', '),
      onFailure: (_) => '',
    );
    final campusId = residencyResult.when(
      onSuccess: (address) => address.campusId,
      onFailure: (_) => null,
    );

    _campusId = campusId;

    final requestsResult = await _ref.read(getResidencyRequestsUseCaseProvider)();
    final requests = requestsResult.when(
      onSuccess: (list) => list,
      onFailure: (_) => <ResidencyRequest>[],
    );
    if (requests.isNotEmpty) {
      state = state.copyWith(
        isLoading: false,
        requests: requests,
        residencyName: residencyName,
        place: place,
      );
      return;
    }

    if (campusId == null || campusId.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No residency selected.',
        residencyName: residencyName,
        place: place,
      );
      return;
    }

    final result = await _ref.read(getAvailableSuitesUseCaseProvider)(campusId);
    result.when(
      onSuccess: (suites) => state = state.copyWith(
        isLoading: false,
        suites: suites,
        residencyName: residencyName,
        place: place,
      ),
      onFailure: (f) => state = state.copyWith(
        isLoading: false,
        errorMessage: f.message,
        residencyName: residencyName,
        place: place,
      ),
    );
  }

  Future<List<AvailableSuite>?> fetchSuites() async {
    final campusId = _campusId;
    if (campusId == null || campusId.isEmpty) return null;
    final result = await _ref.read(getAvailableSuitesUseCaseProvider)(campusId);
    return result.when(onSuccess: (list) => list, onFailure: (_) => null);
  }

  Future<bool> changeClaim(String householdId) async {
    final result = await _ref.read(submitClaimRequestUseCaseProvider)(householdId);
    final ok = result.when(onSuccess: (_) => true, onFailure: (_) => false);
    if (!ok) return false;
    final requestsResult = await _ref.read(getResidencyRequestsUseCaseProvider)();
    requestsResult.when(
      onSuccess: (list) => state = state.copyWith(requests: list),
      onFailure: (_) {},
    );
    return true;
  }

  void selectSuite(AvailableSuite suite) {
    state = state.copyWith(selectedSuite: suite, clearError: true);
  }

  Future<bool> addProperty() async {
    final suite = state.selectedSuite;
    if (suite == null) {
      state = state.copyWith(errorMessage: 'Please select a suite.');
      return false;
    }
    state = state.copyWith(isSubmittingClaim: true, clearError: true);
    final result = await _ref.read(submitClaimRequestUseCaseProvider)(suite.id);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isSubmittingClaim: false,
          properties: [
            ...state.properties,
            Property(
              id: suite.id,
              suite: suite.suite,
              floor: suite.floor,
              type: suite.unitType,
              building: suite.buildingName,
            ),
          ],
          suites: state.suites.where((s) => s.id != suite.id).toList(),
          clearSelection: true,
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isSubmittingClaim: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> updateProperty(Property updated) async {
    final result = await _ref.read(updatePropertyUseCaseProvider)(updated);
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
    final result = await _ref.read(deletePropertyUseCaseProvider)(id);
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
