import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

class HouseholdCarouselCard extends StatelessWidget {
  final Household household;
  final int currentIndex;
  final int total;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const HouseholdCarouselCard({
    super.key,
    required this.household,
    required this.currentIndex,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = household.imageUrl;
    final hasMultiple = total > 1;

    return Container(
      decoration: BoxDecoration(
        border: const Border(
          left: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
          right: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          SizedBox(
            height: 150.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, _) => Container(
                            color: AppColors.border,
                          ),
                          errorWidget: (context, _, __) => Container(
                            color: AppColors.border,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : Container(
                          color: AppColors.border,
                          child: const Icon(
                            Icons.apartment,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ),

                // LEFT / RIGHT ARROWS
                if (hasMultiple) ...[
                  Positioned(
                    left: 8.w,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _ArrowButton(
                        icon: Icons.chevron_left,
                        onTap: onPrevious,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8.w,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _ArrowButton(
                        icon: Icons.chevron_right,
                        onTap: onNext,
                      ),
                    ),
                  ),
                ],

                // IMAGE COUNTER
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '${currentIndex + 1}/$total properties',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // DETAILS SECTION
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 5.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // NAME + ADDRESS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        household.displayName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.h),
                      Text(
                        household.displaySubtitle,
                        style: AppTextStyles.caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // VERTICAL SEPARATOR
                Container(
                  width: 1,
                  height: 48.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  color: AppColors.border,
                ),

                // PROPERTY COUNT
                SizedBox(
                  width: 72.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${currentIndex + 1}/$total',
                        style: AppTextStyles.body.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.h),
                      Text(
                        'properties',
                        style: AppTextStyles.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Icon(icon, size: 20.sp, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
