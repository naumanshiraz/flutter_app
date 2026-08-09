import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/app_text_field.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/auth/domain/entities/user_profile.dart';
import 'package:pms_app/features/auth/presentation/providers/signup_profile_provider.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';

class OnboardingGenderPage extends ConsumerStatefulWidget {
  const OnboardingGenderPage({super.key});

  @override
  ConsumerState<OnboardingGenderPage> createState() => _OnboardingGenderPageState();
}

class _OnboardingGenderPageState extends ConsumerState<OnboardingGenderPage> {
  Gender? _selected;
  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(signupProfileProvider);
    _selected = profile.gender;
    _customController = TextEditingController(text: profile.customGender ?? '');
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    if (_selected == null) return false;
    if (_selected == Gender.other) return _customController.text.trim().isNotEmpty;
    return true;
  }

  void _onNext() {
    if (!_canProceed) return;
    ref.read(signupProfileProvider.notifier).update(
          (p) => p.copyWith(
            gender: _selected,
            customGender: _selected == Gender.other ? _customController.text.trim() : null,
            clearCustomGender: _selected != Gender.other,
          ),
        );
    context.push(RouteNames.onboardingLocation);
  }

  Widget _optionTile(String label, Gender value) {
    final bool isSelected = _selected == value;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () => setState(() => _selected = value),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFF1EC) : Colors.transparent,
            border: Border.all(color: AppColors.primary, width: 1.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.buttonSecondary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      currentStep: 3,
      totalSteps: 5,
      bottomButton: GradientButton(
        label: 'Next', 
        onPressed: _canProceed ? _onNext : null,
        height: 48.h,
        borderRadius: 10.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('What is your gender?', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 12.h),
          Text(
            "This helps us find you more relevant content. It won't be "
            "visible on your profile.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 24.h),
          _optionTile('Female', Gender.female),
          _optionTile('Male', Gender.male),
          _optionTile('Specify another', Gender.other),
          if (_selected == Gender.other) ...[
            SizedBox(height: 8.h),
            AppTextField(
              controller: _customController,
              hintText: "What's your gender",
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }
}
