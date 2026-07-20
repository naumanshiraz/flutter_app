import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// Label-above-input field with a small-radius rounded rectangle,
/// matching the Edit Profile PDF's boxier style (distinct from the
/// full-pill `AppTextField` used on Login/Onboarding).
class LabeledFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  const LabeledFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.inputHint,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

/// Label-above-dropdown / date-picker-trigger variant of
/// [LabeledFormField] — used for Country and Birthdate, which open a
/// picker instead of accepting free text.
class LabeledPickerField extends StatelessWidget {
  final String label;
  final String displayValue;
  final bool isPlaceholder;
  final VoidCallback onTap;

  const LabeledPickerField({
    super.key,
    required this.label,
    required this.displayValue,
    required this.onTap,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayValue,
                  style: isPlaceholder ? AppTextStyles.inputHint : AppTextStyles.inputText,
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
