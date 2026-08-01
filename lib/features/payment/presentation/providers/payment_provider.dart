import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/payment/domain/entities/payment_method.dart';
import 'package:pms_app/features/payment/presentation/providers/payment_di_providers.dart';

class PaymentState {
  final bool isLoading;
  final List<PaymentMethod> methods;
  final String? error;

  const PaymentState({this.isLoading = true, this.methods = const [], this.error});

  PaymentState copyWith({bool? isLoading, List<PaymentMethod>? methods, String? error, bool clearError = false}) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      methods: methods ?? this.methods,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PaymentNotifier extends StateNotifier<PaymentState> {
  final Ref _ref;
  PaymentNotifier(this._ref) : super(const PaymentState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final getMethods = _ref.read(getPaymentMethodsUseCaseProvider);
    final result = await getMethods();
    result.when(
      onSuccess: (methods) => state = state.copyWith(isLoading: false, methods: methods, clearError: true),
      onFailure: (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  Future<void> refresh() => _fetch();
}

final paymentNotifierProvider = StateNotifierProvider.autoDispose<PaymentNotifier, PaymentState>(
  (ref) => PaymentNotifier(ref),
);
