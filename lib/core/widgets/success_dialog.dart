import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// Centered white card over a dark scrim — matches the "Success!" modal
/// shown after re-sending the OTP. Auto-dismisses after [duration]
/// unless the caller pops it first.
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;

  const SuccessDialog({super.key, required this.title, required this.message});

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) async {
    unawaited(
      showDialog<void>(
        context: context,
        barrierColor: AppColors.modalScrim,
        builder: (_) => SuccessDialog(title: title, message: message),
      ),
    );
    await Future.delayed(duration);
    if (context.mounted) Navigator.of(context, rootNavigator: true).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.pageTitle),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
          ],
        ),
      ),
    );
  }
}
