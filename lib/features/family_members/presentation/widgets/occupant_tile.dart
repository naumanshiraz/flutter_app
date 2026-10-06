import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/family_members/domain/entities/occupant.dart';

class OccupantTile extends StatelessWidget {
  final Occupant occupant;

  const OccupantTile({super.key, required this.occupant});

  String get _subtitle {
    final parts = <String>[
      if (occupant.relation != null && occupant.relation!.trim().isNotEmpty) occupant.relation!,
      if (occupant.isPrimary) 'Primary',
    ];
    return parts.isEmpty ? 'Occupant' : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person_outline, size: 20.sp, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  occupant.fullName,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(_subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (!occupant.canUseDevices)
            Icon(Icons.lock_outline, size: 18.sp, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
