import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/greeting.dart';
import 'package:pms_app/core/utils/svg_icons.dart';

class ChatHeader extends StatelessWidget {
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onMenuTap;

  const ChatHeader({super.key, this.onNotificationsTap, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(timeOfDayGreeting(), style: AppTextStyles.pageTitle),
        Row(
          children: [
            InkWell(
              onTap: onNotificationsTap,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SvgIcons.bell()
              ),
            ),
            SizedBox(width: 5.w),
            InkWell(
              onTap: onMenuTap,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SvgIcons.menu(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
