import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Centralized typography. All sizes use ScreenUtil's `.sp` so text scales
/// consistently across device densities, matching the PDF's fixed
/// 375x812 reference frame.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get appTitle => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get pageTitle => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySecondary => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  static TextStyle get inputText => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get inputHint => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get buttonPrimary => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  static TextStyle get buttonSecondary => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );

  static TextStyle get linkText => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );
}
