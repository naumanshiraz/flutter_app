import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/concierge/domain/entities/concierge_category.dart';

class ConciergeCategoryTabs extends StatelessWidget {
  final ConciergeCategory selected;
  final ValueChanged<ConciergeCategory> onChanged;

  const ConciergeCategoryTabs({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: ConciergeCategory.values.map((category) {
          final bool isSelected = category == selected;
          return Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: InkWell(
              onTap: () => onChanged(category),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textPrimary : AppColors.secondary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.label,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
