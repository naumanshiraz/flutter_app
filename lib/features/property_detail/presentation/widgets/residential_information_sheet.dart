import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// Bottom sheet listing ownership/affiliate links and account actions.
/// Opened from [PropertyAccessConfigSheet]'s "Residential information" row.
class ResidentialInformationSheet extends StatelessWidget {
  const ResidentialInformationSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const ResidentialInformationSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              _header(context),
              Divider(height: 1, color: AppColors.border),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  children: [
                    _sectionLabel('Ownership & affiliates'),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigate(context, RouteNames.properties),
                      child: _row('Properties'),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigate(context, RouteNames.familyMembers),
                      child: _row('Occupants'),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigate(context, RouteNames.vehicles),
                      child: _row('Vehicles'),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _navigate(context, RouteNames.pets),
                      child: _row('Pets'),
                    ),
                    SizedBox(height: 12.h),
                    _sectionLabel('Account'),
                    _row('Admin account modification'),
                    _row('Account termination'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 20.w, 12.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.textPrimary, size: 22.sp),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Residential information',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle.copyWith(fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.push(route);
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(label, style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.sp)),
    );
  }

  Widget _row(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
          ),
          Icon(Icons.chevron_right, size: 20.sp, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
