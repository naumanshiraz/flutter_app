import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/property_detail/domain/entities/property_detail.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';
import 'package:pms_app/features/property_detail/presentation/providers/property_detail_di_providers.dart';

class PropertyDetailState {
  final bool isLoading;
  final PropertyDetail? propertyDetail;
  final List<ServiceListing> services;
  final String? error;

  const PropertyDetailState({
    this.isLoading = true,
    this.propertyDetail,
    this.services = const [],
    this.error,
  });

  PropertyDetailState copyWith({
    bool? isLoading,
    PropertyDetail? propertyDetail,
    List<ServiceListing>? services,
    String? error,
    bool clearError = false,
  }) {
    return PropertyDetailState(
      isLoading: isLoading ?? this.isLoading,
      propertyDetail: propertyDetail ?? this.propertyDetail,
      services: services ?? this.services,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Backs the Property Detail screen: hero header + Report/Invoice
/// actions + the "Available services" grid. Parametrized by
/// [propertyId] (`.family`) since this screen is reached for whichever
/// property the user opened.
class PropertyDetailNotifier extends StateNotifier<PropertyDetailState> {
  final Ref _ref;
  final String _propertyId;

  PropertyDetailNotifier(this._ref, this._propertyId) : super(const PropertyDetailState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final getPropertyDetail = _ref.read(getPropertyDetailUseCaseProvider);
    final getServices = _ref.read(getServicesUseCaseProvider);

    // Kicked off together (not chained) so the two calls run concurrently;
    // awaited separately to keep each Result's generic type intact.
    final detailFuture = getPropertyDetail(_propertyId);
    final servicesFuture = getServices(_propertyId);

    final detailResult = await detailFuture;
    final servicesResult = await servicesFuture;

    String? errorMessage;
    PropertyDetail? detail;
    List<ServiceListing> services = const [];

    detailResult.when(
      onSuccess: (data) => detail = data,
      onFailure: (failure) => errorMessage = failure.message,
    );
    servicesResult.when(
      onSuccess: (data) => services = data,
      onFailure: (failure) => errorMessage ??= failure.message,
    );

    state = state.copyWith(
      isLoading: false,
      propertyDetail: detail,
      services: services,
      error: errorMessage,
      clearError: errorMessage == null,
    );
  }

  Future<void> refresh() => _fetch();
}

final propertyDetailNotifierProvider = StateNotifierProvider.autoDispose
    .family<PropertyDetailNotifier, PropertyDetailState, String>(
  (ref, propertyId) => PropertyDetailNotifier(ref, propertyId),
);
