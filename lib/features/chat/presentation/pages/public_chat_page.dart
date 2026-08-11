import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/presentation/pages/group_info_page.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_thread_provider.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_composer.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_thread_header.dart';

class PublicChatArgs {
  final String conversationId;
  final String title;
  final String avatarInitials;
  final int subscriberCount;

  const PublicChatArgs({
    required this.conversationId,
    required this.title,
    this.avatarInitials = '',
    this.subscriberCount = 0,
  });
}

class PublicChatPage extends ConsumerWidget {
  final PublicChatArgs args;

  const PublicChatPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final threadKey = (threadId: args.conversationId, isPostComments: false);
    final state = ref.watch(chatThreadProvider(threadKey));
    final notifier = ref.read(chatThreadProvider(threadKey).notifier);

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
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
            Expanded(child: _buildMessages(state, notifier)),
            ChatComposer(isSending: state.isSending, onSend: notifier.sendMessage),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(ChatThreadState state, ChatThreadNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 32.sp),
              SizedBox(height: 12.h),
              Text(state.errorMessage!, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
              SizedBox(height: 16.h),
              ElevatedButton(onPressed: notifier.refresh, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (state.messages.isEmpty) {
      return Center(child: Text('No messages yet. Say hello!', style: AppTextStyles.bodySecondary));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: state.messages.length,
      itemBuilder: (context, index) => ChatMessageBubble(message: state.messages[index]),
    );
  }
}
