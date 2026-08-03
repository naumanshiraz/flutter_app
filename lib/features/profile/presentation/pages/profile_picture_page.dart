import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';
import 'package:pms_app/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:pms_app/features/profile/presentation/widgets/profile_avatar_circle.dart';

class ProfilePicturePage extends ConsumerWidget {
  const ProfilePicturePage({super.key});

  Future<void> _pick(BuildContext context, WidgetRef ref, ProfilePictureSource source) async {
    final notifier = ref.read(editProfileProvider.notifier);
    final ok = await notifier.pickAvatar(source);
    if (ok && context.mounted) {
      final state = ref.read(editProfileProvider);
   
      if (state.profile.avatarPath != null && state.profile.avatarPath!.isNotEmpty) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 12.h),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      state.profile.name.isEmpty ? 'Profile picture' : state.profile.name,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 48.w), // balances the leading IconButton
                ],
              ),
              SizedBox(height: 60.h),
              Center(
                child: ProfileAvatarCircle(
                  avatarPath: state.profile.avatarPath,
                  initials: state.profile.initials,
                  size: 200,
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                'Please add your profile picture',
                textAlign: TextAlign.center,
                style: AppTextStyles.pageTitle.copyWith(fontSize: 19.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                'Keep your personal details private. Information you add here '
                'is shared to authorities of your property management '
                'organization or company.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              if (state.errorMessage != null) ...[
                SizedBox(height: 16.h),
                Text(
                  state.errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              const Spacer(),
              GradientButton(
                label: 'Take a photo',
                isLoading: state.isPickingImage,
                onPressed: () => _pick(context, ref, ProfilePictureSource.camera),
              ),
              SizedBox(height: 12.h),
              SecondaryButton(
                label: 'Camera roll',
                onPressed: state.isPickingImage
                    ? null
                    : () => _pick(context, ref, ProfilePictureSource.gallery),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
