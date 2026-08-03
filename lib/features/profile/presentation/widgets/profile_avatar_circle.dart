import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class ProfileAvatarCircle extends StatelessWidget {
  final String? avatarPath;
  final String initials;
  final double size;

  const ProfileAvatarCircle({
    super.key,
    required this.avatarPath,
    required this.initials,
    this.size = 160,
  });

  @override
  Widget build(BuildContext context) {
    final double diameter = size.w;

    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.border),
      clipBehavior: Clip.antiAlias,
      child: (avatarPath != null && avatarPath!.isNotEmpty)
          ? Image.file(
              File(avatarPath!),
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) => _Initials(text: initials),
            )
          : _Initials(text: initials),
    );
  }
}

class _Initials extends StatelessWidget {
  final String text;
  const _Initials({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: AppTextStyles.appTitle.copyWith(fontSize: 40.sp, fontWeight: FontWeight.w800),
      ),
    );
  }
}
