import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_pill_button.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileSummary profile;
  final VoidCallback onEditProfile;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Avatar(profile: profile),
        SizedBox(height: 16.h),
        Text(
          profile.name,
          textAlign: TextAlign.center,
          style: AppTextStyles.pageTitle.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 6.h),
        if (profile.email.isNotEmpty)
          Text(profile.email, style: AppTextStyles.bodySecondary),
        if (profile.phone.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Text(
            profile.phone,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
        SizedBox(height: 16.h),
        GradientPillButton(
          label: 'Edit profile', 
          onPressed: onEditProfile,  
          borderRadius: 10.r,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final ProfileSummary profile;
  const _Avatar({required this.profile});

  @override
  Widget build(BuildContext context) {
    final double size = 96.w;
    final avatar = profile.avatarUrl;
    final bool isRemoteUrl = avatar != null && avatar.startsWith('http');
    final bool isLocalFile = avatar != null && avatar.isNotEmpty && !isRemoteUrl;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.border),
      clipBehavior: Clip.antiAlias,
      child: isRemoteUrl
          ? CachedNetworkImage(
              imageUrl: avatar,
              fit: BoxFit.cover,
              placeholder: (context, _) => _InitialsFallback(profile: profile),
              errorWidget: (context, _, __) => _InitialsFallback(profile: profile),
            )
          : isLocalFile
              ? Image.file(
                  File(avatar),
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) => _InitialsFallback(profile: profile),
                )
              : _InitialsFallback(profile: profile),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  final ProfileSummary profile;
  const _InitialsFallback({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        profile.initials,
        style: AppTextStyles.appTitle.copyWith(fontSize: 30.sp, fontWeight: FontWeight.w800),
      ),
    );
  }
}
