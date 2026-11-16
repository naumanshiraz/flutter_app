import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_di_providers.dart';

class InvoiceListState {
  final bool isLoading;
  final List<InvoiceSummary> invoices;
  final String? error;

  const InvoiceListState({this.isLoading = true, this.invoices = const [], this.error});
}

class InvoiceListNotifier extends StateNotifier<InvoiceListState> {
  final Ref _ref;
  final String _householdId;

  InvoiceListNotifier(this._ref, this._householdId) : super(const InvoiceListState()) {
    refresh();
  }

  Future<void> refresh() async {
    state = const InvoiceListState();
    final result = await _ref.read(getInvoicesUseCaseProvider)(_householdId);
    if (!mounted) return;
    state = result.when(
      onSuccess: (invoices) => InvoiceListState(isLoading: false, invoices: invoices),
      onFailure: (failure) => InvoiceListState(isLoading: false, error: failure.message),
    );
  }
}

final invoiceListNotifierProvider =
    StateNotifierProvider.autoDispose.family<InvoiceListNotifier, InvoiceListState, String>(
  (ref, householdId) => InvoiceListNotifier(ref, householdId),
);
