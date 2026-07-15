import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// Rounded pill-shaped text field matching every input in the PDF
/// ("Enter your phone number or email address", "Enter your email
/// address", "Enter your name", ...).
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.r),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28.r),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}

/// Rounded dropdown field ("Date", "Choose") used on the onboarding
/// screens. Kept generic so both the birthdate picker and the location
/// picker can reuse it.
class AppDropdownField<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AppDropdownField({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          hint: Text(hintText, style: AppTextStyles.inputHint),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
