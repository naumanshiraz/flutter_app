import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/presentation/pages/group_info_page.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/presentation/providers/announcement_feed_provider.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_thread_provider.dart';
import 'package:pms_app/features/chat/presentation/widgets/announcement_post_card.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_composer.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_thread_header.dart';

class PostDetailArgs {
  final String conversationId;
  final String title;
  final String avatarInitials;
  final int subscriberCount;
  final String postId;

  const PostDetailArgs({
    required this.conversationId,
    required this.title,
    this.avatarInitials = '',
    this.subscriberCount = 0,
    required this.postId,
  });
}

class PostDetailPage extends ConsumerWidget {
  final PostDetailArgs args;

  const PostDetailPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(announcementFeedProvider(args.conversationId));
    final threadKey = (threadId: args.postId, isPostComments: true);
    final threadState = ref.watch(chatThreadProvider(threadKey));
    final threadNotifier = ref.read(chatThreadProvider(threadKey).notifier);

    final AnnouncementPost? post = feedState.posts
        .cast<AnnouncementPost?>()
        .firstWhere((p) => p?.id == args.postId, orElse: () => null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChatThreadHeader(
        title: args.title, 
        subscriberCount: args.subscriberCount,
        onInfoTap: () => context.push(
          RouteNames.chatGroupInfo,
          extra: GroupInfoArgs(
            conversationId: args.conversationId,
            title: args.title,
            avatarInitials: args.avatarInitials,
            subscriberCount: args.subscriberCount,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.greyBackground,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    if (post != null)
                      AnnouncementPostCard(
                        post: post,
                        onCommentsTap: () {},
                      )
                    else if (feedState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Text('Post not found.', style: AppTextStyles.bodySecondary),
                    SizedBox(height: 20.h),
                    if (threadState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (threadState.errorMessage != null)
                      Center(
                        child: Text(threadState.errorMessage!, style: AppTextStyles.bodySecondary),
                      )
                    else if (threadState.messages.isEmpty)
                      Center(child: Text('No comments yet. Be the first to comment.', style: AppTextStyles.bodySecondary))
                    else
                      for (final message in threadState.messages) ChatMessageBubble(message: message),
                  ],
                ),
              ),  
            ),
            ChatComposer(
              isSending: threadState.isSending,
              onSend: threadNotifier.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
