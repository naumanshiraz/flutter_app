import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/utils/validators.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/presentation/providers/auth_providers.dart';

/// UI state for the Login screen (phone/email entry). Deliberately a
/// plain immutable class rather than Freezed — it's presentation-only
/// state with a single `copyWith`, so the codegen overhead isn't worth it.
class LoginFormState {
  final String identifier;
  final bool isSubmitting;
  final String? errorMessage;
  final OtpSession? requestedOtp; // set once request succeeds; page listens for it

  const LoginFormState({
    this.identifier = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.requestedOtp,
  });

  bool get isValid => Validators.isValidIdentifier(identifier);

  LoginFormState copyWith({
    String? identifier,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    OtpSession? requestedOtp,
    bool clearRequestedOtp = false,
  }) {
    return LoginFormState(
      identifier: identifier ?? this.identifier,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      requestedOtp: clearRequestedOtp ? null : (requestedOtp ?? this.requestedOtp),
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Ref _ref;

  LoginFormNotifier(this._ref) : super(const LoginFormState());

  void onIdentifierChanged(String value) {
    state = state.copyWith(identifier: value, clearError: true);
  }

  /// Requests an OTP for the current identifier. [purpose] distinguishes
  /// the "Log in" vs "Sign up" button on the same screen — both funnel
  /// into the same OTP-verification page afterwards.
  Future<void> submit(OtpPurpose purpose) async {
    if (!state.isValid || state.isSubmitting) return;

    state = state.copyWith(isSubmitting: true, clearError: true);

    final identifierType =
        Validators.isEmail(state.identifier) ? IdentifierType.email : IdentifierType.phone;

    final useCase = _ref.read(requestOtpUseCaseProvider);
    final result = await useCase(
      identifier: state.identifier.trim(),
      identifierType: identifierType,
      purpose: purpose,
    );

    result.when(
      onSuccess: (session) {
        state = state.copyWith(isSubmitting: false, requestedOtp: session);
      },
      onFailure: (failure) {
        state = state.copyWith(isSubmitting: false, errorMessage: failure.message);
      },
    );
  }

  /// Called by the page right after navigating away, so a stale
  /// `requestedOtp` doesn't re-trigger navigation if the user comes back.
  void consumeRequestedOtp() {
    state = state.copyWith(clearRequestedOtp: true);
  }
}

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(ref),
);
