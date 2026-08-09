import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/grey_button.dart';

class ReportSheet extends StatelessWidget {
  const ReportSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const ReportSheet(),
    );
  }

  static const _reports = ['May, 2024 - Monthly report', 'April, 2024 - Monthly report', 'March, 2024 - Monthly report'];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.25,
      maxChildSize: 0.8,
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
                Text('Report', style: AppTextStyles.caption),
                SizedBox(height: 12.h),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: _reports.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) => Row(
                      children: [
                        Expanded(
                          child: Text(_reports[index],
                              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp),),
                        ),
                        Icon(Icons.file_download_outlined, size: 20.sp, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: SizedBox(
                    width: 120.w,
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
}
