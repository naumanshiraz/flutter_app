import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/validators.dart';
import 'package:pms_app/core/widgets/app_text_field.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/auth/presentation/providers/signup_profile_provider.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';

class OnboardingEmailPage extends ConsumerStatefulWidget {
  const OnboardingEmailPage({super.key});

  @override
  ConsumerState<OnboardingEmailPage> createState() => _OnboardingEmailPageState();
}

class _OnboardingEmailPageState extends ConsumerState<OnboardingEmailPage> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(signupProfileProvider).email);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    final error = Validators.emailError(_controller.text);
    setState(() => _error = error);
    if (error != null) return;

    ref.read(signupProfileProvider.notifier).update(
          (p) => p.copyWith(email: _controller.text.trim()),
        );
    context.push(RouteNames.onboardingPhone);
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      currentStep: 0,
      totalSteps: 5,
      bottomButton: GradientButton(
        label: 'Next', 
        onPressed: _onNext,
        height: 48.h,
        borderRadius: 10.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('What is your email?', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 20.h),
          AppTextField(
            controller: _controller,
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            errorText: _error,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
        ],
      ),
    );
  }
}
