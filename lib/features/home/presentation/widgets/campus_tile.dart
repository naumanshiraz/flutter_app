import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';

class CampusTile extends StatelessWidget {
  final Campus campus;

  const CampusTile({super.key, required this.campus});

  @override
  Widget build(BuildContext context) {
    final thumbUrl = campus.thumbUrl;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: (thumbUrl != null && thumbUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: thumbUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, _) => Container(color: AppColors.border),
                      errorWidget: (context, _, __) => Container(
                        color: AppColors.border,
                        child: const Icon(Icons.apartment, color: AppColors.textSecondary),
                      ),
                    )
                  : Container(
                      color: AppColors.border,
                      child: const Icon(Icons.apartment, color: AppColors.textSecondary),
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: campus.name,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  if (campus.description != null && campus.description!.isNotEmpty)
                    TextSpan(text: '  ·  ${campus.description}', style: AppTextStyles.caption),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
