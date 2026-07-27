import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/activity_log/domain/entities/log_entry.dart';

class LogListTile extends StatelessWidget {
  final LogEntry entry;

  const LogListTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final titleColor = entry.isMissed ? AppColors.primary : AppColors.textPrimary;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            entry.kind == LogEntryKind.call ? Icons.call_outlined : Icons.person_outline,
            size: 22.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp, color: titleColor)),
                Text(entry.location, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(entry.dateLabel, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
