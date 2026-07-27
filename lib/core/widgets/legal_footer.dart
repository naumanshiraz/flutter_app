import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';

class LegalFooter extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;

  const LegalFooter({super.key, this.onTermsTap, this.onPrivacyTap});

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(fontSize: 12.sp, color: AppColors.textSecondary);
    final linkStyle = baseStyle.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: baseStyle,
          children: [
            const TextSpan(text: 'Please read our '),
            TextSpan(
              text: 'Terms of Service',
              style: linkStyle,
              recognizer: onTermsTap != null
                  ? (TapGestureRecognizer()..onTap = onTermsTap)
                  : null,
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: linkStyle,
              recognizer: onPrivacyTap != null
                  ? (TapGestureRecognizer()..onTap = onPrivacyTap)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
