import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/activity_log/presentation/providers/activity_log_provider.dart';
import 'package:pms_app/features/activity_log/presentation/widgets/log_filter_tabs.dart';
import 'package:pms_app/features/activity_log/presentation/widgets/log_list_tile.dart';

class ActivityLogSheet extends ConsumerWidget {
  const ActivityLogSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => const ActivityLogSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activityLogNotifierProvider);
    final notifier = ref.read(activityLogNotifierProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                    LogFilterTabs(selected: state.filter, onChanged: notifier.setFilter),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
              Expanded(child: _buildBody(state, notifier, scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(ActivityLogState state, ActivityLogNotifier notifier, ScrollController scrollController) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.logs.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 32.sp),
              SizedBox(height: 12.h),
              Text(state.error!, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
              SizedBox(height: 16.h),
              ElevatedButton(onPressed: notifier.refresh, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final logs = state.visibleLogs;

    if (logs.isEmpty) {
      return Center(child: Text('No entries yet.', style: AppTextStyles.bodySecondary));
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primary,
      child: ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: logs.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) => LogListTile(entry: logs[index]),
      ),
    );
  }
}
