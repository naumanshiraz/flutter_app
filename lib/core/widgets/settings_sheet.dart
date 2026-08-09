import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/splash/presentation/providers/app_initialization_provider.dart';

/// "Settings" sheet opened from the Menu sheet's Settings row.
class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const SettingsSheet(),
    );
  }

  Future<void> _logOut(BuildContext context, WidgetRef ref) async {
    await ref.read(secureStorageServiceProvider).clearAll();
    await ref.read(appInitializationProvider.notifier).refresh();
    if (!context.mounted) return;
    Navigator.of(context).pop();
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    Text('Settings', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  children: [
                    _sectionLabel('Account'),
                    _row(
                      'Edit profile',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push(RouteNames.editProfile);
                      },
                    ),
                    _row('Account management'),
                    _row('Interest tuner'),
                    _row('Email notifications'),
                    _row('Push notifications'),
                    _row('Reports and violations center', external: true),
                    _sectionLabel('Login'),
                    _row('Add account'),
                    _row('Security'),
                    _row('Log out', showChevron: false, onTap: () => _logOut(context, ref)),
                    _sectionLabel('Support'),
                    _row('Frequently asked questions', external: true),
                    _row('Terms of service', external: true),
                    _row('Privacy policy', external: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 6.h),
      child: Text(label, style: AppTextStyles.caption),
    );
  }

  Widget _row(String label, {bool external = false, bool showChevron = true, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
            ),
            if (external)
              Icon(Icons.north_east, size: 18.sp, color: AppColors.textSecondary)
            else if (showChevron)
              Icon(Icons.chevron_right, size: 20.sp, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
