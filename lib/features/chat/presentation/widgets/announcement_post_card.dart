import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';

class AnnouncementPostCard extends StatelessWidget {
  final AnnouncementPost post;
  final VoidCallback onCommentsTap;
  final bool highlighted;

  const AnnouncementPostCard({
    super.key,
    required this.post,
    required this.onCommentsTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(highlighted ? 12.w : 0),
      decoration: highlighted
          ? BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 1.4),
              borderRadius: BorderRadius.circular(12.r),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.border,
                child: Text(post.authorInitials, style: AppTextStyles.avatarInitials),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp),
                    ),
                    Text(post.authorSubtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(post.body, style: AppTextStyles.body.copyWith(fontSize: 13.sp)),
          if (post.imageUrl != null) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: AspectRatio(
                aspectRatio: 1.4,
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => Container(color: AppColors.border),
                  errorWidget: (context, _, __) => Container(color: AppColors.border),
                ),
              ),
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.thumb_up_alt_outlined, size: 16.sp, color: AppColors.textSecondary),
              SizedBox(width: 16.w),
              Icon(Icons.share_outlined, size: 16.sp, color: AppColors.textSecondary),
              const Spacer(),
              InkWell(
                onTap: onCommentsTap,
                child: Text(
                  '${post.likeCount} likes, ${post.commentCount} comments',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
