import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// The outline "Report" + gradient "Invoice" buttons shown under the
/// property header. Presentational only — the page supplies the
/// callbacks (both currently no-ops until a Report/Invoice module
/// exists, same "wire the UI, stub the destination" approach used for
/// unbuilt bottom-nav tabs).
class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onReportPressed;
  final VoidCallback onInvoicePressed;

  const ActionButtonsRow({
    super.key,
    required this.onReportPressed,
    required this.onInvoicePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onReportPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(vertical: 8.h), // Reduced from 12.h
              minimumSize: Size(double.infinity, 36.h), // Optional
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Optional
            ),
            child: Text('Report', style: AppTextStyles.buttonSecondary),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onInvoicePressed,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Center(
                  child: Text(
                    'Invoice',
                    style: AppTextStyles.buttonPrimary,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
