import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/greeting.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onMenuTap;

  const ChatHeader({super.key, this.onNotificationsTap, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(timeOfDayGreeting(), style: AppTextStyles.appTitle),
        Row(
          children: [
            InkWell(
              onTap: onNotificationsTap,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Icon(Icons.notifications_none, size: 24.sp, color: AppColors.textPrimary),
              ),
            ),
            InkWell(
              onTap: onMenuTap,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Icon(Icons.menu, size: 24.sp, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
