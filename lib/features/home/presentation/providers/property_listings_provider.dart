import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/home/domain/entities/property_listing.dart';
import 'package:pms_app/features/home/presentation/providers/home_di_providers.dart';

class PropertyListingsState {
  final List<PropertyListing> listings;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  const PropertyListingsState({
    this.listings = const [],
    this.isLoading = true,
    this.errorMessage,
    this.searchQuery = '',
  });

  PropertyListingsState copyWith({
    List<PropertyListing>? listings,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? searchQuery,
  }) {
    return PropertyListingsState(
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PropertyListingsNotifier extends StateNotifier<PropertyListingsState> {
  final Ref _ref;
  Timer? _debounce;

  PropertyListingsNotifier(this._ref) : super(const PropertyListingsState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = _ref.read(getPropertyListingsUseCaseProvider);
    final result = await useCase(searchQuery: state.searchQuery);
    result.when(
      onSuccess: (listings) {
        state = state.copyWith(listings: listings, isLoading: false);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  /// Debounced so every keystroke doesn't re-trigger the (mocked)
  /// network call — matches how a real search-as-you-type would behave
  /// against a live API.
  void onSearchChanged(String query) {
    state = state.copyWith(searchQuery: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _fetch);
  }

  Future<void> refresh() => _fetch();

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final propertyListingsProvider =
    StateNotifierProvider.autoDispose<PropertyListingsNotifier, PropertyListingsState>(
  (ref) => PropertyListingsNotifier(ref),
);
