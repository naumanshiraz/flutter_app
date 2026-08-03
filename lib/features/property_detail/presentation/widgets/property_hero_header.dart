import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';

class PropertyHeroHeader extends StatelessWidget {
  final List<String> imageUrls;
  final VoidCallback onBackPressed;

  const PropertyHeroHeader({
    super.key,
    required this.imageUrls,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final heroUrl = imageUrls.isNotEmpty ? imageUrls.first : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          SizedBox(
            height: 180.h,
            width: double.infinity,
            child: heroUrl == null
                ? Container(color: AppColors.border)
                : CachedNetworkImage(
                    imageUrl: heroUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.border),
                    errorWidget: (context, url, error) => Container(color: AppColors.border),
                  ),
          ),
          Positioned(
            top: 12.h,
            left: 12.w,
            child: InkWell(
              onTap: onBackPressed,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new, size: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
