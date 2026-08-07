import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/bottom_nav_bar.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/chat/presentation/pages/chat_list_page.dart';
import 'package:pms_app/features/service_profile/domain/entities/service_profile.dart';
import 'package:pms_app/features/service_profile/presentation/providers/service_profile_provider.dart';
import 'package:pms_app/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:pms_app/features/service_profile/presentation/widgets/reply_sheet.dart';
import 'package:pms_app/features/service_profile/presentation/widgets/add_comment_sheet.dart';

class ServiceProfilePage extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceProfilePage({super.key, required this.serviceId});

    @override
  ConsumerState<ServiceProfilePage> createState() => _ServiceProfilePageState();
}

class _ServiceProfilePageState extends ConsumerState<ServiceProfilePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serviceProfileNotifierProvider(widget.serviceId));
    final notifier = ref.read(serviceProfileNotifierProvider(widget.serviceId).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildBody(context, state, notifier, ref.watch(editProfileProvider).profile.initials),
            const ChatListPage(),
            const PlaceholderPage(
              title: 'Cart',
              routeName: '/main-home/service-profile (tab: cart)',
            ),
            const PlaceholderPage(
              title: 'Community',
              routeName: '/main-home/service-profile (tab: community)',
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            if (index == 0) {
              context.go(RouteNames.mainHome);
            } else if (index == 3) {
              context.go(RouteNames.home);
            } else {
              setState(() => _selectedIndex = index);
            }
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, 
    ServiceProfileState state, 
    ServiceProfileNotifier notifier,
    String currentUserInitials,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null || state.profile == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 32.sp),
              SizedBox(height: 12.h),
              Text(state.error ?? 'Not found.', textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
              SizedBox(height: 16.h),
              ElevatedButton(onPressed: notifier.refresh, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final profile = state.profile!;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(16.r)),
              child: SizedBox(
                height: 180.h,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: profile.heroImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.border),
                  errorWidget: (context, url, error) => Container(color: AppColors.border),
                ),
              ),
            ),
            Positioned(
              top: 12.h,
              left: 12.w,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                  child: Icon(Icons.arrow_back_ios_new, size: 16.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.border,
                    child: Text(profile.name.substring(0, 2).toUpperCase(), style: AppTextStyles.avatarInitials),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
                        Text(profile.subtitle, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      elevation: 0,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Follow',
                      style: AppTextStyles.buttonSecondary.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.textBlack,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.h),
              Text(profile.tagline, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
              SizedBox(height: 8.h),
              Text(profile.description, style: AppTextStyles.body.copyWith(fontSize: 13.sp)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Contact',
                        style: AppTextStyles.buttonSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Share',
                          style: AppTextStyles.buttonPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${profile.comments.length} comments', style: AppTextStyles.caption),
                  Row(
                    children: [
                      for (int i = 0; i < 5; i++) ... [
                        Icon(Icons.circle, size: 10.sp, color: i < profile.rating.round() ? AppColors.primary : AppColors.border),
                        if (i < 4) SizedBox(width: 3.w),
                      ],
                      SizedBox(width: 6.w),
                      Text(profile.rating.toStringAsFixed(1), style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppColors.border, height: 24),
              for (final comment in profile.comments) _commentRow(context, comment),
              SizedBox(height: 16.h),
              InkWell(
                onTap: () => AddCommentSheet.show(context, serviceId: widget.serviceId),
                child: Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.border,
                    child: Text(currentUserInitials, style: AppTextStyles.avatarInitials),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Add a comment',
                              style: AppTextStyles.caption,
                            ),
                          ),
                          Icon(
                            Icons.link_rounded,
                            size: 18.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _commentRow(BuildContext context, ServiceComment comment) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.only(left: 42.w, top: 8.h),
      trailing: comment.replies.isEmpty
          ? const SizedBox.shrink()
          : const Icon(Icons.keyboard_arrow_down),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.border,
            child: Text(
              comment.authorInitial,
              style: AppTextStyles.avatarInitials,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  comment.text,
                  style: AppTextStyles.body.copyWith(fontSize: 13.sp),
                ),
                SizedBox(height: 4.h),
                InkWell(
                  onTap: () => ReplySheet.show(
                    context,
                    serviceId: widget.serviceId,
                    commentId: comment.id,
                    authorName: comment.authorName,
                  ),
                  child: Text(
                    'Reply',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      children: comment.replies.map((reply) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14.r,
                backgroundColor: AppColors.border,
                child: Text(
                  reply.authorInitial,
                  style: AppTextStyles.avatarInitials,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply.authorName,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      reply.text,
                      style: AppTextStyles.body.copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
