import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/home/domain/entities/property_listing.dart';

class PropertyCard extends StatelessWidget {
  final PropertyListing listing;
  final VoidCallback? onTap;

  const PropertyCard({super.key, required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 2.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: listing.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, _) => Container(color: AppColors.border),
                errorWidget: (context, _, __) => Container(
                  color: AppColors.border,
                  child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            listing.title,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            listing.managementCompany,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
