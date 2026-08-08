import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_category.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_grid_layout.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_service_item.dart';
import 'package:pms_app/features/concierge/presentation/providers/concierge_di_providers.dart';

class ConciergeServicesState {
  final List<ConciergeServiceItem> items;
  final ConciergeGridLayout layout;
  final ConciergeCategory category;
  final bool isLoading;
  final String? errorMessage;

  const ConciergeServicesState({
    this.items = const [],
    this.layout = ConciergeGridLayout.grid,
    this.category = ConciergeCategory.forYou,
    this.isLoading = true,
    this.errorMessage,
  });

  ConciergeServicesState copyWith({
    List<ConciergeServiceItem>? items,
    ConciergeGridLayout? layout,
    ConciergeCategory? category,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ConciergeServicesState(
      items: items ?? this.items,
      layout: layout ?? this.layout,
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ConciergeServicesNotifier extends StateNotifier<ConciergeServicesState> {
  final Ref _ref;

  ConciergeServicesNotifier(this._ref) : super(const ConciergeServicesState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = _ref.read(getConciergeServicesUseCaseProvider);
    final result = await useCase(category: state.category);
    result.when(
      onSuccess: (feed) => state = state.copyWith(
        items: feed.items,
        layout: feed.layout,
        isLoading: false,
      ),
      onFailure: (failure) =>
          state = state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  void onCategoryChanged(ConciergeCategory category) {
    if (category == state.category) return;
    state = state.copyWith(category: category);
    _fetch();
  }

  Future<void> refresh() => _fetch();
}

final conciergeServicesProvider =
    StateNotifierProvider.autoDispose<ConciergeServicesNotifier, ConciergeServicesState>(
  (ref) => ConciergeServicesNotifier(ref),
);
