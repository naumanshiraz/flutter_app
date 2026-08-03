import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/service_profile/domain/entities/service_profile.dart';
import 'package:pms_app/features/service_profile/presentation/providers/service_profile_di_providers.dart';

class ServiceProfileState {
  final bool isLoading;
  final ServiceProfile? profile;
  final String? error;

  const ServiceProfileState({this.isLoading = true, this.profile, this.error});

  ServiceProfileState copyWith({bool? isLoading, ServiceProfile? profile, String? error, bool clearError = false}) {
    return ServiceProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ServiceProfileNotifier extends StateNotifier<ServiceProfileState> {
  final Ref _ref;
  final String _serviceId;

  ServiceProfileNotifier(this._ref, this._serviceId) : super(const ServiceProfileState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final getProfile = _ref.read(getServiceProfileUseCaseProvider);
    final result = await getProfile(_serviceId);
    result.when(
      onSuccess: (profile) => state = state.copyWith(isLoading: false, profile: profile, clearError: true),
      onFailure: (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> refresh() => _fetch();
}

final serviceProfileNotifierProvider =
    StateNotifierProvider.autoDispose.family<ServiceProfileNotifier, ServiceProfileState, String>(
  (ref, serviceId) => ServiceProfileNotifier(ref, serviceId),
);
