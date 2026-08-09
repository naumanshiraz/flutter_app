import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/main_gate_control_sheet.dart';

class AccessManagementSheet extends StatelessWidget {
  const AccessManagementSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const AccessManagementSheet(),
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
              const Divider(height: 1, color: AppColors.border),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  children: [
                    _sectionLabel('Control'),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => MainGateControlSheet.show(context),
                      child: _row('Main gate control'),
                    ),
                    _row('Front door control'),
                    _row('North campus gate'),
                    _row('South campus gate'),
                    _row('Elevator control'),
                    SizedBox(height: 12.h),
                    _sectionLabel('Safety and security'),
                    _row('Fire alarm notification'),
                    _row('Burglar detection'),
                    SizedBox(height: 12.h),
                    _sectionLabel('Billing and account'),
                    _row('Payment and billing'),
                    _row('Residential configuration'),
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
              'Access management',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle.copyWith(fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
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
