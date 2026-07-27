import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class MenuSheet extends StatelessWidget {
  const MenuSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => const MenuSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Menu', style: AppTextStyles.caption),
            SizedBox(height: 16.h),
            _MenuItem(
              label: 'Add another property',
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.properties);
              },
            ),
            SizedBox(height: 16.h),
            _MenuItem(
              label: 'Settings',
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(height: 16.h),
            _MenuItem(
              label: 'Edit profile',
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.editProfile);
              },
            ),
            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: 120.w,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                  ),
                  child: Text('Close', style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.textPrimary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
      ),
    );
  }
}
