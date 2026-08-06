import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/domain/entities/conversation_type.dart';
import 'package:pms_app/features/chat/presentation/pages/announcement_feed_page.dart';
import 'package:pms_app/features/chat/presentation/pages/public_chat_page.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_conversations_provider.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_conversation_tile.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_filter_tabs.dart';

class ChatConversationsView extends ConsumerWidget {
  const ChatConversationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatConversationsProvider);
    final notifier = ref.read(chatConversationsProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
            sliver: SliverToBoxAdapter(
              child: ChatFilterTabs(
                selected: state.filter,
                onChanged: notifier.onFilterChanged,
              ),
            ),
          ),
          if (state.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            )
          else if (state.errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 32.sp, color: AppColors.error),
                      SizedBox(height: 10.h),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySecondary,
                      ),
                      SizedBox(height: 12.h),
                      TextButton(onPressed: notifier.refresh, child: const Text('Try again')),
                    ],
                  ),
                ),
              ),
            )
          else if (state.conversations.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No conversations found.', style: AppTextStyles.bodySecondary),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final conversation = state.conversations[index];
                    return Column(
                      children: [
                        ChatConversationTile(
                          conversation: conversation,
                          onTap: () {
                            if (conversation.type == ConversationType.announcement) {
                              context.push(
                                RouteNames.chatAnnouncement,
                                extra: AnnouncementFeedArgs(
                                  conversationId: conversation.id,
                                  title: conversation.title,
                                  subscriberCount: conversation.subscriberCount,
                                ),
                              );
                            } else {
                              context.push(
                                RouteNames.chatPublicGroup,
                                extra: PublicChatArgs(
                                  conversationId: conversation.id,
                                  title: conversation.title,
                                  subscriberCount: conversation.subscriberCount,
                                ),
                              );
                            }
                          },
                        ),
                        if (index != state.conversations.length - 1)
                          const Divider(height: 1, color: AppColors.border),
                      ],
                    );
                  },
                  childCount: state.conversations.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
