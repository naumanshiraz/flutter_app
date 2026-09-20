import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class LabeledFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? trailing;

  const LabeledFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.enabled = true,
    this.errorText,
    this.suffixIcon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    final field = TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.inputHint,
        errorText: null, // handled manually below
        suffixIcon: suffixIcon,
        filled: !enabled,
        fillColor: AppColors.secondary,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.primary,
            width: 1.4,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: hasError ? AppColors.error : AppColors.border,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        SizedBox(height: 8.h),
        trailing == null
            ? field
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: field),
                  SizedBox(width: 0.w),
                  trailing!,
                ],
              ),
        if (hasError) ...[
          SizedBox(height: 4.h),
          Text(
            errorText!,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}

class LabeledPickerField extends StatelessWidget {
  final String label;
  final String displayValue;
  final bool isPlaceholder;
  final VoidCallback onTap;
  final String? errorText;

  const LabeledPickerField({
    super.key,
    required this.label,
    required this.displayValue,
    required this.onTap,
    this.isPlaceholder = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.4 : 1.0,
              ),
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
        if (hasError) ...[
          SizedBox(height: 4.h),
          Text(
            errorText!,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
