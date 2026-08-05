import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/presentation/providers/auth_providers.dart';

enum OtpVerifyStatus { idle, verifying, success }

class OtpVerificationState {
  final String identifier;
  final IdentifierType identifierType;
  final OtpPurpose purpose;
  final String code;
  final Duration remaining;
  final bool canResend;
  final bool isResending;
  final OtpVerifyStatus status;
  final String? errorMessage;

  const OtpVerificationState({
    required this.identifier,
    required this.identifierType,
    required this.purpose,
    this.code = '',
    this.remaining = AppConstants.otpResendDuration,
    this.canResend = false,
    this.isResending = false,
    this.status = OtpVerifyStatus.idle,
    this.errorMessage,
  });

  String get formattedRemaining {
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  OtpVerificationState copyWith({
    String? code,
    Duration? remaining,
    bool? canResend,
    bool? isResending,
    OtpVerifyStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OtpVerificationState(
      identifier: identifier,
      identifierType: identifierType,
      purpose: purpose,
      code: code ?? this.code,
      remaining: remaining ?? this.remaining,
      canResend: canResend ?? this.canResend,
      isResending: isResending ?? this.isResending,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Arguments GoRouter passes when navigating to the OTP screen —
/// avoids stringly-typed query params for something this structured.
/// Implements `==`/`hashCode` because it's used as a Riverpod `.family`
/// parameter, which relies on value equality (not identity) to resolve
/// to the same provider instance across rebuilds.
class OtpVerificationArgs {
  final String identifier;
  final IdentifierType identifierType;
  final OtpPurpose purpose;
  final Map<String, String>? metadata;

  const OtpVerificationArgs({
    required this.identifier,
    required this.identifierType,
    required this.purpose,
    this.metadata,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtpVerificationArgs &&
          runtimeType == other.runtimeType &&
          identifier == other.identifier &&
          identifierType == other.identifierType &&
          purpose == other.purpose;

  @override
  int get hashCode => Object.hash(identifier, identifierType, purpose);
}

class OtpVerificationNotifier extends StateNotifier<OtpVerificationState> {
  final Ref _ref;
  Timer? _ticker;

  OtpVerificationNotifier(this._ref, OtpVerificationArgs args)
      : super(
          OtpVerificationState(
            identifier: args.identifier,
            identifierType: args.identifierType,
            purpose: args.purpose,
          ),
        ) {
    _startCountdown();
  }

  void _startCountdown() {
    _ticker?.cancel();
    state = state.copyWith(
      remaining: AppConstants.otpResendDuration,
      canResend: false,
    );
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final next = state.remaining - const Duration(seconds: 1);
      if (next <= Duration.zero) {
        timer.cancel();
        state = state.copyWith(remaining: Duration.zero, canResend: true);
      } else {
        state = state.copyWith(remaining: next);
      }
    });
  }

  void onCodeChanged(String value) {
    state = state.copyWith(code: value, clearError: true);
  }

  Future<void> resend() async {
    if (!state.canResend || state.isResending) return;
    state = state.copyWith(isResending: true, clearError: true);

    final useCase = _ref.read(requestOtpUseCaseProvider);
    final result = await useCase(
      identifier: state.identifier,
      identifierType: state.identifierType,
      purpose: state.purpose,
    );

    result.when(
      onSuccess: (_) {
        state = state.copyWith(isResending: false, code: '');
        _startCountdown();
      },
      onFailure: (failure) {
        state = state.copyWith(isResending: false, errorMessage: failure.message);
      },
    );
  }

  Future<bool> verify() async {
    if (state.code.length != 6 || state.status == OtpVerifyStatus.verifying) {
      return false;
    }
    state = state.copyWith(status: OtpVerifyStatus.verifying, clearError: true);

    final verifyUseCase = _ref.read(verifyOtpUseCaseProvider);
    final verifyResult = await verifyUseCase(identifier: state.identifier, code: state.code);

    final verified = verifyResult.when(
      onSuccess: (ok) => ok,
      onFailure: (failure) {
        state = state.copyWith(status: OtpVerifyStatus.idle, errorMessage: failure.message);
        return false;
      },
    );

    if (!verified) return false;

    // Login flow ends here: mark the session authenticated immediately.
    // Sign-up flow instead proceeds to onboarding — the page decides
    // that based on `state.purpose`, this notifier just confirms the
    // code was correct.
    if (state.purpose == OtpPurpose.login) {
      final completeLogin = _ref.read(completeLoginUseCaseProvider);
      final result = await completeLogin(state.identifier);
      result.when(
        onSuccess: (_) => state = state.copyWith(status: OtpVerifyStatus.success),
        onFailure: (failure) {
          state = state.copyWith(status: OtpVerifyStatus.idle, errorMessage: failure.message);
        },
      );
      return state.status == OtpVerifyStatus.success;
    }

    state = state.copyWith(status: OtpVerifyStatus.success);
    return true;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final otpVerificationProvider = StateNotifierProvider.autoDispose
    .family<OtpVerificationNotifier, OtpVerificationState, OtpVerificationArgs>(
  (ref, args) => OtpVerificationNotifier(ref, args),
);
