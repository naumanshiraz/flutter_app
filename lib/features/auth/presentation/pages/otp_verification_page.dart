import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/validators.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/legal_footer.dart';
import 'package:pms_app/core/widgets/success_dialog.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/presentation/providers/otp_verification_provider.dart';
import 'package:pms_app/features/auth/presentation/widgets/otp_input_boxes.dart';
import 'package:pms_app/features/splash/presentation/providers/app_initialization_provider.dart';

/// Matches the PDF's OTP screens: countdown timer, masked
/// email/phone target, 6-box code entry, Confirm CTA, and a
/// "Click to re-send" link that shows the Success! modal once a fresh
/// code goes out.
class OtpVerificationPage extends ConsumerWidget {
  final OtpVerificationArgs args;

  const OtpVerificationPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(otpVerificationProvider(args));
    final notifier = ref.read(otpVerificationProvider(args).notifier);

    ref.listen<OtpVerificationState>(otpVerificationProvider(args), (previous, next) async {
      final justResent = previous != null &&
          previous.isResending &&
          !next.isResending &&
          next.errorMessage == null;
      if (justResent) {
        await SuccessDialog.show(
          context,
          title: 'Success!',
          message:
              'A 6-digit verification code has been successfully dispatched '
              'to your ${next.identifierType == IdentifierType.email ? 'email address' : 'phone number'}: '
              '${Validators.maskIdentifier(next.identifier)}',
        );
      }

      if (next.status == OtpVerifyStatus.success && previous?.status != OtpVerifyStatus.success) {
        if (next.purpose == OtpPurpose.login) {
          // Sync the app-wide session check, then go straight Home.
          // ignore: unused_result
          ref.read(appInitializationProvider.notifier).refresh();
          if (context.mounted) context.go(RouteNames.home);
        } else {
          if (context.mounted) context.go(RouteNames.onboardingEmail);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100.h),
              Center(
                child: Text(
                  state.formattedRemaining,
                  style: AppTextStyles.appTitle.copyWith(fontSize: 32.sp),
                ),
              ),
              SizedBox(height: 20.h),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.bodySecondary,
                  children: [
                    TextSpan(
                      text: 'Please enter the 6 digit code we sent to your '
                          '${state.identifierType == IdentifierType.email ? 'email address' : 'phone number'}: ',
                    ),
                    TextSpan(
                      text: Validators.maskIdentifier(state.identifier),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              OtpInputBoxes(
                onChanged: notifier.onCodeChanged,
                onCompleted: (_) => notifier.verify(),
              ),
              if (state.errorMessage != null) ...[
                SizedBox(height: 12.h),
                Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              SizedBox(height: 32.h),
              GradientButton(
                label: 'Confirm',
                isLoading: state.status == OtpVerifyStatus.verifying,
                onPressed: state.code.length == 6 ? notifier.verify : null,
              ),
              SizedBox(height: 20.h),
              Center(
                child: Column(
                  children: [
                    Text('Having trouble with verification?', style: AppTextStyles.bodySecondary),
                    SizedBox(height: 4.h),
                    GestureDetector(
                      onTap: state.canResend && !state.isResending ? notifier.resend : null,
                      child: Text(
                        'Click to re-send',
                        style: AppTextStyles.linkText.copyWith(
                          color: state.canResend ? AppColors.primary : AppColors.disabled,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const LegalFooter(),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
