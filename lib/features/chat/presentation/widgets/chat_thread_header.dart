import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/svg_icons.dart';

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
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 44.w,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new, size: 18.sp, color: AppColors.textPrimary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
          if (subscriberCount > 0)
            Text(
              '$subscriberCount subscribers',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: onInfoTap,
            icon: SvgIcons.info(),
          ),
        ],
      )
    );
  }
}
