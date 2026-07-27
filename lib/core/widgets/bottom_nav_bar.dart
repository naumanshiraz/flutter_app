import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const List<IconData> _outlineIcons = [
    Icons.home_outlined,
    Icons.chat_bubble_outline,
    Icons.shopping_cart_outlined,
    Icons.people_alt_outlined,
  ];

  static const List<IconData> _filledIcons = [
    Icons.home_filled,
    Icons.chat_bubble,
    Icons.shopping_cart,
    Icons.people_alt,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_outlineIcons.length, (index) {
          final bool isSelected = index == selectedIndex;
          return InkWell(
            onTap: () => onTap(index),
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Icon(
                isSelected ? _filledIcons[index] : _outlineIcons[index],
                size: 26.sp,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          );
        }),
      ),
    );
  }
}
