import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// The search field + "+" button row beneath the profile header.
class SearchAddBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddTap;

  const SearchAddBar({
    super.key,
    required this.onSearchChanged,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48.h,
            child: TextField(
              onChanged: onSearchChanged,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextStyles.inputHint,
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        InkWell(
          onTap: onAddTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(Icons.add, size: 26.sp, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
