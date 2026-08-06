import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';

class ChatConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final VoidCallback onTap;

  const ChatConversationTile({super.key, required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sender = conversation.lastMessageSender;
    final preview = sender != null && sender.isNotEmpty
        ? '$sender: ${conversation.lastMessagePreview}'
        : conversation.lastMessagePreview;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(conversation: conversation),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(conversation.timeLabel, style: AppTextStyles.caption),
                SizedBox(height: 10.h),
                Icon(Icons.info_outline, size: 18.sp, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final ChatConversation conversation;
  const _Avatar({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final double size = 48.w;
    final url = conversation.avatarUrl;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.border),
      clipBehavior: Clip.antiAlias,
      child: (url != null && url.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (context, _) => _InitialsFallback(conversation: conversation),
              errorWidget: (context, _, __) => _InitialsFallback(conversation: conversation),
            )
          : _InitialsFallback(conversation: conversation),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  final ChatConversation conversation;
  const _InitialsFallback({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        conversation.avatarInitials,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w700, 
          color: AppColors.textBlack
        ),
      ),
    );
  }
}
