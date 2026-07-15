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

class OnboardingPhonePage extends ConsumerStatefulWidget {
  const OnboardingPhonePage({super.key});

  @override
  ConsumerState<OnboardingPhonePage> createState() => _OnboardingPhonePageState();
}

class _OnboardingPhonePageState extends ConsumerState<OnboardingPhonePage> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(signupProfileProvider).phone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNext() {
    final error = Validators.phoneError(_controller.text);
    setState(() => _error = error);
    if (error != null) return;

    ref.read(signupProfileProvider.notifier).update(
          (p) => p.copyWith(phone: _controller.text.trim()),
        );
    context.push(RouteNames.onboardingProfile);
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      currentStep: 1,
      totalSteps: 5,
      bottomButton: GradientButton(label: 'Next', onPressed: _onNext),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('What is phone number?', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 20.h),
          AppTextField(
            controller: _controller,
            hintText: 'Enter your phone number',
            keyboardType: TextInputType.phone,
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
