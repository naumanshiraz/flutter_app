import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/properties/domain/entities/residency_request.dart';
import 'package:pms_app/features/properties/presentation/providers/properties_di_providers.dart';

class ResidencyRequestsState {
  final bool isLoading;
  final List<ResidencyRequest> requests;
  final String? error;

  const ResidencyRequestsState({this.isLoading = true, this.requests = const [], this.error});

  bool get hasPending => requests.any((r) => r.isPending);

  ResidencyRequest? get current {
    if (requests.isEmpty) return null;
    return requests.firstWhere((r) => r.isPending, orElse: () => requests.first);
  }
}

class ResidencyRequestsNotifier extends StateNotifier<ResidencyRequestsState> {
  final Ref _ref;

  ResidencyRequestsNotifier(this._ref) : super(const ResidencyRequestsState()) {
    load();
  }

  Future<void> load() async {
    state = const ResidencyRequestsState();
    final result = await _ref.read(getResidencyRequestsUseCaseProvider)();
    result.when(
      onSuccess: (list) => state = ResidencyRequestsState(isLoading: false, requests: list),
      onFailure: (f) => state = ResidencyRequestsState(isLoading: false, error: f.message),
    );
  }
}

final residencyRequestsProvider =
    StateNotifierProvider.autoDispose<ResidencyRequestsNotifier, ResidencyRequestsState>(
  (ref) => ResidencyRequestsNotifier(ref),
);
