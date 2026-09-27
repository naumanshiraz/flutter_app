import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';

IconData _iconFromName(String? name) {
  switch (name) {
    case 'door':
      return Icons.door_front_door_outlined;
    case 'gate':
      return Icons.gite_outlined;
    case 'barrier':
      return Icons.account_balance_outlined;
    case 'elevator':
      return Icons.elevator_outlined;
    default:
      return Icons.device_unknown_outlined;
  }
}

class ControlCard extends StatelessWidget {
  final Control control;
  final VoidCallback onToggle;

  const ControlCard({
    super.key,
    required this.control,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12.w,
        18.h,
        12.w,
        6.h, // reduce bottom padding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _iconFromName(control.iconName),
            size: 26.sp,
            color: AppColors.textPrimary,
          ),

          SizedBox(height: 6.h),

          Text(
            control.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 2.h),

          Text(
            control.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 4.h),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 24.h,
              child: Transform.scale(
                scale: 0.65,
                alignment: Alignment.centerRight,
                child: Switch.adaptive(
                  value: control.isOn,
                  onChanged: (_) => onToggle(),
                  activeThumbColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFF6B7280),
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}