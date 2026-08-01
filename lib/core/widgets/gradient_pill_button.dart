import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class GradientPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double borderRadius;

  const GradientPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius.r),
            onTap: enabled ? onPressed : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16.sp, color: Colors.white),
                    SizedBox(width: 6.w),
                  ],
                  Text(label, style: AppTextStyles.buttonPrimary.copyWith(fontSize: 14.sp)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
