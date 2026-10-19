import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';
import 'package:pms_app/features/join_requests/domain/entities/received_invitation.dart';
import 'package:pms_app/features/join_requests/presentation/providers/join_requests_di_providers.dart';

class ListState<T> {
  final bool isLoading;
  final List<T> items;
  final String? error;

  const ListState({this.isLoading = true, this.items = const [], this.error});
}

class JoinRequestsNotifier extends StateNotifier<ListState<JoinRequest>> {
  final Ref _ref;

  JoinRequestsNotifier(this._ref) : super(const ListState()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const ListState();
    final result = await _ref.read(getIncomingJoinRequestsUseCaseProvider)();
    result.when(
      onSuccess: (list) => state = ListState(isLoading: false, items: list),
      onFailure: (f) => state = ListState(isLoading: false, error: f.message),
    );
  }

  Future<String?> approve(String id) async {
    final result = await _ref.read(approveJoinRequestUseCaseProvider)(id);
    return _removeOnSuccess(id, result.when(onSuccess: (_) => null, onFailure: (f) => f.message));
  }

  Future<String?> reject(String id, String reason) async {
    final result = await _ref.read(rejectJoinRequestUseCaseProvider)(id, reason);
    return _removeOnSuccess(id, result.when(onSuccess: (_) => null, onFailure: (f) => f.message));
  }

  String? _removeOnSuccess(String id, String? error) {
    if (error == null) {
      state = ListState(isLoading: false, items: state.items.where((r) => r.id != id).toList());
    }
    return error;
  }
}

final joinRequestsProvider =
    StateNotifierProvider.autoDispose<JoinRequestsNotifier, ListState<JoinRequest>>((ref) => JoinRequestsNotifier(ref));

class ReceivedInvitationsNotifier extends StateNotifier<ListState<ReceivedInvitation>> {
  final Ref _ref;

  ReceivedInvitationsNotifier(this._ref) : super(const ListState()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const ListState();
    final result = await _ref.read(getReceivedInvitationsUseCaseProvider)();
    result.when(
      onSuccess: (list) => state = ListState(isLoading: false, items: list),
      onFailure: (f) => state = ListState(isLoading: false, error: f.message),
    );
  }

  Future<String?> accept(String id) async {
    final result = await _ref.read(acceptInvitationUseCaseProvider)(id);
    return _removeOnSuccess(id, result.when(onSuccess: (_) => null, onFailure: (f) => f.message));
  }

  Future<String?> decline(String id) async {
    final result = await _ref.read(declineInvitationUseCaseProvider)(id);
    return _removeOnSuccess(id, result.when(onSuccess: (_) => null, onFailure: (f) => f.message));
  }

  String? _removeOnSuccess(String id, String? error) {
    if (error == null) {
      state = ListState(isLoading: false, items: state.items.where((r) => r.id != id).toList());
    }
    return error;
  }
}

final receivedInvitationsProvider =
    StateNotifierProvider.autoDispose<ReceivedInvitationsNotifier, ListState<ReceivedInvitation>>(
  (ref) => ReceivedInvitationsNotifier(ref),
);
