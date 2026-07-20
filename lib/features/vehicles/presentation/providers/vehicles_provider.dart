import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/presentation/providers/vehicles_di_providers.dart';

class VehiclesState {
  final bool isLoading;
  final bool isSubmittingDraft;
  final List<Vehicle> vehicles;
  final Vehicle draft;
  final String? errorMessage;

  const VehiclesState({
    this.isLoading = true,
    this.isSubmittingDraft = false,
    this.vehicles = const [],
    required this.draft,
    this.errorMessage,
  });

  VehiclesState copyWith({
    bool? isLoading,
    bool? isSubmittingDraft,
    List<Vehicle>? vehicles,
    Vehicle? draft,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VehiclesState(
      isLoading: isLoading ?? this.isLoading,
      isSubmittingDraft: isSubmittingDraft ?? this.isSubmittingDraft,
      vehicles: vehicles ?? this.vehicles,
      draft: draft ?? this.draft,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Backs the "Please share details of your vehicles" screen (list +
/// draft add-form) *and* the Edit-vehicle screen — same shared-notifier
/// pattern as `familyMembersProvider` / `propertiesProvider`.
class VehiclesNotifier extends StateNotifier<VehiclesState> {
  final Ref _ref;
  static const _uuid = Uuid();

  VehiclesNotifier(this._ref) : super(VehiclesState(draft: Vehicle(id: _uuid.v4()))) {
    _load();
  }

  Future<void> _load() async {
    final useCase = _ref.read(getVehiclesUseCaseProvider);
    final result = await useCase();
    result.when(
      onSuccess: (vehicles) {
        state = state.copyWith(isLoading: false, vehicles: vehicles);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  void updateDraft({String? type, String? brand, String? engineType, String? licensePlate}) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        type: type,
        brand: brand,
        engineType: engineType,
        licensePlate: licensePlate,
      ),
      clearError: true,
    );
  }

  /// Validates and persists the current draft, then resets the draft
  /// (with a fresh id) so the form is ready for the next vehicle.
  Future<bool> addDraftAsVehicle() async {
    if (!state.draft.isValid) {
      state = state.copyWith(errorMessage: 'Please complete every field before adding.');
      return false;
    }
    state = state.copyWith(isSubmittingDraft: true, clearError: true);

    final useCase = _ref.read(addVehicleUseCaseProvider);
    final result = await useCase(state.draft);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          isSubmittingDraft: false,
          vehicles: [...state.vehicles, state.draft],
          draft: Vehicle(id: _uuid.v4()),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isSubmittingDraft: false, errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> updateVehicle(Vehicle updated) async {
    final useCase = _ref.read(updateVehicleUseCaseProvider);
    final result = await useCase(updated);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(
          vehicles: state.vehicles.map((v) => v.id == updated.id ? updated : v).toList(),
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteVehicle(String id) async {
    final useCase = _ref.read(deleteVehicleUseCaseProvider);
    final result = await useCase(id);

    return result.when(
      onSuccess: (_) {
        state = state.copyWith(vehicles: state.vehicles.where((v) => v.id != id).toList());
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
    );
  }
}

final vehiclesProvider = StateNotifierProvider.autoDispose<VehiclesNotifier, VehiclesState>(
  (ref) => VehiclesNotifier(ref),
);
