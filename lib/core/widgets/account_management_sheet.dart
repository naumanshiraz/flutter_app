import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/greetings/presentation/providers/greetings_provider.dart';

class AccountManagementSheet extends ConsumerWidget {
  const AccountManagementSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const AccountManagementSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greetingsState = ref.watch(greetingsProvider);

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
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      ),
                    ),
                    Text(
                      'Account management',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  children: [
                    _sectionLabel('Affiliates'),
                    _row(
                      'Affiliates management',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push(RouteNames.affiliatesManagement);
                      },
                    ),
                    if (greetingsState.isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else
                      for (final greeting in greetingsState.greetings) _row(greeting.label),
                    _sectionLabel('Account'),
                    _row(
                      'Account termination',
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push(RouteNames.accountTermination);
                      },
                    ),
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

  Widget _row(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
            ),
            Icon(Icons.chevron_right, size: 20.sp, color: AppColors.textBlack),
          ],
        ),
      ),
    );
  }
}
