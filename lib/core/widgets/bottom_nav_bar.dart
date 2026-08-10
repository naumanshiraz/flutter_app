import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/utils/svg_icons.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static final List<Widget> _outlineIcons = [
    SvgIcons.home(),
    SvgIcons.chat(),
    SvgIcons.cart(),
    SvgIcons.users(),
  ];

  static final List<Widget> _filledIcons = [
    SvgIcons.home_filled(),
    SvgIcons.chat_filled(),
    SvgIcons.cart_filled(),
    SvgIcons.users_filled(),
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
              child: isSelected ? _filledIcons[index] : _outlineIcons[index],
            ),
          );
        }),
      ),
    );
  }
}
