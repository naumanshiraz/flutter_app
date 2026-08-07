import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/presentation/pages/group_info_page.dart';
import 'package:pms_app/features/chat/presentation/pages/post_detail_page.dart';
import 'package:pms_app/features/chat/presentation/providers/announcement_feed_provider.dart';
import 'package:pms_app/features/chat/presentation/widgets/announcement_post_card.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_thread_header.dart';

class AnnouncementFeedArgs {
  final String conversationId;
  final String title;
  final String avatarInitials;
  final int subscriberCount;

  const AnnouncementFeedArgs({
    required this.conversationId,
    required this.title,
    this.avatarInitials = '',
    this.subscriberCount = 0,
  });
}

class AnnouncementFeedPage extends ConsumerWidget {
  final AnnouncementFeedArgs args;

  const AnnouncementFeedPage({super.key, required this.args});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(announcementFeedProvider(args.conversationId));
    final notifier = ref.read(announcementFeedProvider(args.conversationId).notifier);

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
        child: _buildBody(context, state, notifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AnnouncementFeedState state,
    AnnouncementFeedNotifier notifier,
  ) {
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

    if (state.posts.isEmpty) {
      return Center(child: Text('No posts yet.', style: AppTextStyles.bodySecondary));
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primary,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: state.posts.length,
        separatorBuilder: (context, index) => SizedBox(height: 20.h),
        itemBuilder: (context, index) {
          final post = state.posts[index];
          return AnnouncementPostCard(
            post: post,
            onCommentsTap: () => context.push(
              RouteNames.chatPostDetail,
              extra: PostDetailArgs(
                conversationId: args.conversationId,
                title: args.title,
                subscriberCount: args.subscriberCount,
                postId: post.id,
              ),
            ),
          );
        },
      ),
    );
  }
}
