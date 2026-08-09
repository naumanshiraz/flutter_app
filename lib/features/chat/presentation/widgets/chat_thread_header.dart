import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class ChatThreadHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int subscriberCount;
  final VoidCallback? onInfoTap;

  const ChatThreadHeader({
    super.key,
    required this.title,
    this.subscriberCount = 0,
    this.onInfoTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leadingWidth: 44.w,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.textPrimary),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
          if (subscriberCount > 0)
            Text('$subscriberCount subscribers', style: AppTextStyles.caption),
        ],
      ),
      actions: [
        IconButton(
          onPressed: onInfoTap,
          icon: Icon(Icons.info_outline, size: 20.sp, color: AppColors.textBlack),
        ),
      ],
    );
  }
}
