import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isMine) return _buildMine();
    return _buildTheirs();
  }

  Widget _buildTheirs() {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.border,
            child: Text(message.senderInitials, style: AppTextStyles.avatarInitials),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      message.senderName,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(message.timeLabel, style: AppTextStyles.caption),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(message.text, style: AppTextStyles.body.copyWith(fontSize: 13.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMine() {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(message.text, style: AppTextStyles.body.copyWith(fontSize: 13.sp)),
            ),
          ),
          SizedBox(width: 6.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(message.timeLabel, style: AppTextStyles.caption),
              SizedBox(height: 2.h),
              Icon(
                message.isRead ? Icons.done_all : Icons.done,
                size: 14.sp,
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
