import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

/// A single "Available services" tile. [imageAspectRatio] is decided by
/// the *caller* (`ServicesMasonryGrid`, based on the screen-level
/// `ServicesGridLayout`) — this card itself has no opinion on whether
/// it's the tall tile, the banner tile, or a plain grid tile, it just
/// renders whatever slot it's given. The card chrome (name, description,
/// "..." menu) stays identical across every slot so the grid reads as
/// one consistent design regardless of arrangement.
class ServiceCard extends StatelessWidget {
  final ServiceListing service;
  final double? imageAspectRatio;
  final double? imageHeight;
  final VoidCallback? onMorePressed;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.imageAspectRatio = 1.3,
    this.imageHeight,
    this.onMorePressed,
    this.onTap,
  }) : assert(imageAspectRatio != null || imageHeight != null);

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: service.imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: AppColors.border),
        errorWidget: (context, url, error) => Container(
          color: AppColors.border,
          child: Icon(Icons.storefront_outlined, color: AppColors.textSecondary, size: 24.sp),
        ),
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // `imageHeight` (used for the tall left tile in vertical-mode
          // layout) is an explicit pixel value computed by the grid so
          // it lines up exactly with the two stacked tiles beside it.
          // Deliberately NOT `IntrinsicHeight` + `Expanded` — that
          // combo is unreliable once a network image is in the tree
          // (intrinsic-height passes can't resolve a flexible child),
          // which is what collapsed the right column to one tile.
          imageHeight != null
              ? SizedBox(height: imageHeight, width: double.infinity, child: image)
              : AspectRatio(aspectRatio: imageAspectRatio!, child: image),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  service.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
                ),
              ),
              InkWell(
                onTap: onMorePressed,
                child: Icon(Icons.more_horiz, size: 18.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
          Text(
            service.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(fontSize: 11.sp),
          ),
        ],
      ),
    );
  }
}
