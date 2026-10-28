import 'package:cached_network_image/cached_network_image.dart';
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
      child: LayoutBuilder(
        builder: (_, constraints) {
          final bubbleWidth = constraints.maxWidth * 0.75;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SenderAvatar(message: message),

              SizedBox(width: 6.w),

              SizedBox(
                width: bubbleWidth,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    8.w,
                    8.h,
                    8.w,
                    8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.senderName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              right: 42.w,
                            ),
                            
                            child: Text(
                              message.text,
                              style: AppTextStyles.body.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Text(
                              message.timeLabel,
                              style: AppTextStyles.caption.copyWith(
                                fontSize: 13.sp,
                                color: const Color(0xFF718096),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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

class _SenderAvatar extends StatelessWidget {
  final ChatMessage message;
  const _SenderAvatar({required this.message});

  @override
  Widget build(BuildContext context) {
    final url = message.senderAvatarUrl;
    final initials = Text(
      message.senderInitials,
      style: AppTextStyles.avatarInitials.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );

    return CircleAvatar(
      radius: 21.r,
      child: (url != null && url.isNotEmpty)
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: url,
                width: 42.r,
                height: 42.r,
                fit: BoxFit.cover,
                placeholder: (_, __) => Center(child: initials),
                errorWidget: (_, __, ___) => Center(child: initials),
              ),
            )
          : initials,
    );
  }
}
