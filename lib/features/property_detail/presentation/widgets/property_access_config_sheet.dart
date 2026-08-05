import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/access_management_sheet.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/residential_information_sheet.dart';
import 'package:pms_app/core/widgets/grey_button.dart';

class PropertyAccessConfigSheet extends StatelessWidget {
  const PropertyAccessConfigSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const PropertyAccessConfigSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.25,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Property configuration', style: AppTextStyles.caption),
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => AccessManagementSheet.show(context),
                        child: _row('Access management'),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => ResidentialInformationSheet.show(context),
                        child: _row('Residential information'),
                      ),
                      SizedBox(height: 20),
                      _row('Property management agreement', showDownload: true),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: SizedBox(
                    width: 100.w,
                    child: GreyButton(
                      label: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      height: 44.h,
                      borderRadius: 10.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _row(String label, {bool showDownload = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
        ),
        if (showDownload) Icon(Icons.file_download_outlined, size: 20.sp, color: AppColors.textSecondary),
      ],
    );
  }
}
