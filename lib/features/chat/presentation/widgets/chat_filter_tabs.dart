import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/domain/entities/chat_filter.dart';

class ChatFilterTabs extends StatelessWidget {
  final ChatFilter selected;
  final ValueChanged<ChatFilter> onChanged;

  const ChatFilterTabs({super.key, required this.selected, required this.onChanged});

  static const Map<ChatFilter, String> _labels = {
    ChatFilter.all: 'All',
    ChatFilter.unread: 'Unread',
    ChatFilter.groups: 'Groups',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _labels.entries.map((entry) {
        final bool isSelected = entry.key == selected;
        return Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: InkWell(
            onTap: () => onChanged(entry.key),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.textPrimary : AppColors.secondary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                entry.value,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
