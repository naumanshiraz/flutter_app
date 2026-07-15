import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/validators.dart';
import 'package:pms_app/core/widgets/app_text_field.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/auth/presentation/providers/signup_profile_provider.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';

class OnboardingProfilePage extends ConsumerStatefulWidget {
  const OnboardingProfilePage({super.key});

  @override
  ConsumerState<OnboardingProfilePage> createState() => _OnboardingProfilePageState();
}

class _OnboardingProfilePageState extends ConsumerState<OnboardingProfilePage> {
  late final TextEditingController _nameController;
  DateTime? _birthDate;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(signupProfileProvider);
    _nameController = TextEditingController(text: profile.name);
    _birthDate = profile.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13, now.month, now.day),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _onNext() {
    final error = Validators.nameError(_nameController.text);
    setState(() => _nameError = error);
    if (error != null) return;

    ref.read(signupProfileProvider.notifier).update(
          (p) => p.copyWith(name: _nameController.text.trim(), birthDate: _birthDate),
        );
    context.push(RouteNames.onboardingGender);
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      currentStep: 2,
      totalSteps: 5,
      bottomButton: GradientButton(label: 'Next', onPressed: _onNext),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Please enter your name', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 20.h),
          AppTextField(
            controller: _nameController,
            hintText: 'Enter your name',
            errorText: _nameError,
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
          ),
          SizedBox(height: 32.h),
          Text('Enter your birthdate', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 12.h),
          Text(
            "Your birthdate helps us provide more personalized recommendations "
            "and relevant services. We don't share this information and it "
            "won't be visible on your profile.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 20.h),
          InkWell(
            onTap: _pickBirthDate,
            borderRadius: BorderRadius.circular(28.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _birthDate == null ? 'Date' : DateFormat.yMMMd().format(_birthDate!),
                    style: _birthDate == null ? AppTextStyles.inputHint : AppTextStyles.inputText,
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
