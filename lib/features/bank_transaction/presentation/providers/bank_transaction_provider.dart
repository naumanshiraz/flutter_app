import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/bank_transaction/domain/entities/bank_transaction_detail.dart';
import 'package:pms_app/features/bank_transaction/presentation/providers/bank_transaction_di_providers.dart';

class BankTransactionState {
  final bool isLoading;
  final BankTransactionDetail? detail;
  final String? error;

  const BankTransactionState({this.isLoading = true, this.detail, this.error});

  BankTransactionState copyWith({bool? isLoading, BankTransactionDetail? detail, String? error, bool clearError = false}) {
    return BankTransactionState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class BankTransactionNotifier extends StateNotifier<BankTransactionState> {
  final Ref _ref;
  final String _paymentMethodId;

  BankTransactionNotifier(this._ref, this._paymentMethodId) : super(const BankTransactionState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final getDetail = _ref.read(getBankTransactionDetailUseCaseProvider);
    final result = await getDetail(_paymentMethodId);
    result.when(
      onSuccess: (detail) => state = state.copyWith(isLoading: false, detail: detail, clearError: true),
      onFailure: (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> refresh() => _fetch();
}

final bankTransactionNotifierProvider =
    StateNotifierProvider.autoDispose.family<BankTransactionNotifier, BankTransactionState, String>(
  (ref, paymentMethodId) => BankTransactionNotifier(ref, paymentMethodId),
);
