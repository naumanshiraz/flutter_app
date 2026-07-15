import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/app_text_field.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/legal_footer.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/presentation/providers/login_form_provider.dart';
import 'package:pms_app/features/auth/presentation/providers/otp_verification_provider.dart';
import 'package:pms_app/features/splash/presentation/widgets/splash_logo.dart';

/// Matches the PDF's first onboarding frame: logo + app name, an
/// email/phone field, and Log in / Sign up CTAs, both of which request
/// an OTP for the same identifier — the OTP screen decides afterwards
/// whether to go straight Home (Log in) or into profile onboarding
/// (Sign up) based on the `purpose` it was launched with.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _controller = TextEditingController();
  OtpPurpose? _pendingPurpose;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginFormState>(loginFormProvider, (previous, next) {
      final session = next.requestedOtp;
      if (session != null && _pendingPurpose != null) {
        ref.read(loginFormProvider.notifier).consumeRequestedOtp();
        context.push(
          RouteNames.otpVerification,
          extra: OtpVerificationArgs(
            identifier: session.identifier,
            identifierType: session.identifierType,
            purpose: _pendingPurpose!,
          ),
        );
      }
    });

    final formState = ref.watch(loginFormProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60.h),
              Center(child: SplashLogo(size: 88.w)),
              SizedBox(height: 20.h),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: AppTextStyles.appTitle,
              ),
              SizedBox(height: 80.h),
              AppTextField(
                controller: _controller,
                hintText: 'Enter your phone number or email address',
                keyboardType: TextInputType.emailAddress,
                errorText: formState.errorMessage,
                onChanged: ref.read(loginFormProvider.notifier).onIdentifierChanged,
              ),
              SizedBox(height: 16.h),
              Text(
                'We will send you a 6-digit verification code for a '
                'password-free sign-in',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              const Spacer(),
              GradientButton(
                label: 'Log in',
                isLoading: formState.isSubmitting && _pendingPurpose == OtpPurpose.login,
                onPressed: (formState.isValid && !formState.isSubmitting)
                    ? () {
                        _pendingPurpose = OtpPurpose.login;
                        ref.read(loginFormProvider.notifier).submit(OtpPurpose.login);
                      }
                    : null,
              ),
              SizedBox(height: 12.h),
              SecondaryButton(
                label: 'Sign up',
                onPressed: (formState.isValid && !formState.isSubmitting)
                    ? () {
                        _pendingPurpose = OtpPurpose.signup;
                        ref.read(loginFormProvider.notifier).submit(OtpPurpose.signup);
                      }
                    : null,
              ),
              SizedBox(height: 24.h),
              const LegalFooter(),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
