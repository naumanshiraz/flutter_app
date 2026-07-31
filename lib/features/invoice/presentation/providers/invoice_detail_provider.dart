import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_di_providers.dart';

class InvoiceDetailState {
  final bool isLoading;
  final InvoiceDetail? detail;
  final String? error;

  const InvoiceDetailState({this.isLoading = true, this.detail, this.error});

  InvoiceDetailState copyWith({bool? isLoading, InvoiceDetail? detail, String? error, bool clearError = false}) {
    return InvoiceDetailState(
      isLoading: isLoading ?? this.isLoading,
      detail: detail ?? this.detail,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class InvoiceDetailNotifier extends StateNotifier<InvoiceDetailState> {
  final Ref _ref;
  final String _invoiceId;

  InvoiceDetailNotifier(this._ref, this._invoiceId) : super(const InvoiceDetailState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final getInvoiceDetail = _ref.read(getInvoiceDetailUseCaseProvider);
    final result = await getInvoiceDetail(_invoiceId);
    result.when(
      onSuccess: (detail) => state = state.copyWith(isLoading: false, detail: detail, clearError: true),
      onFailure: (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> refresh() => _fetch();
}

final invoiceDetailNotifierProvider =
    StateNotifierProvider.autoDispose.family<InvoiceDetailNotifier, InvoiceDetailState, String>(
  (ref, invoiceId) => InvoiceDetailNotifier(ref, invoiceId),
);
