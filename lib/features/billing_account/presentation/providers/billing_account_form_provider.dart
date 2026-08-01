import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/billing_account/domain/entities/billing_account.dart';
import 'package:pms_app/features/billing_account/presentation/providers/billing_account_di_providers.dart';

enum BillingAccountSubmitStatus { idle, submitting, success, error }

class BillingAccountFormState {
  final BillingAccountSubmitStatus status;
  final String? error;

  const BillingAccountFormState({this.status = BillingAccountSubmitStatus.idle, this.error});
}

class BillingAccountFormNotifier extends StateNotifier<BillingAccountFormState> {
  final Ref _ref;
  BillingAccountFormNotifier(this._ref) : super(const BillingAccountFormState());

  Future<void> submit(BillingAccount account) async {
    state = const BillingAccountFormState(status: BillingAccountSubmitStatus.submitting);
    final submitUseCase = _ref.read(submitBillingAccountUseCaseProvider);
    final result = await submitUseCase(account);
    result.when(
      onSuccess: (_) => state = const BillingAccountFormState(status: BillingAccountSubmitStatus.success),
      onFailure: (failure) =>
          state = BillingAccountFormState(status: BillingAccountSubmitStatus.error, error: failure.message),
    );
  }
}

final billingAccountFormNotifierProvider =
    StateNotifierProvider.autoDispose<BillingAccountFormNotifier, BillingAccountFormState>(
  (ref) => BillingAccountFormNotifier(ref),
);
