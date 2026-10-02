import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/confirm_dialog.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/assigned_households_provider.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

class AssignedPropertiesPage extends ConsumerWidget {
  final Affiliate affiliate;

  const AssignedPropertiesPage({super.key, required this.affiliate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assignedHouseholdsProvider(affiliate.id));
    final notifier = ref.read(assignedHouseholdsProvider(affiliate.id).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text(
          affiliate.name.isEmpty ? 'Affiliate' : affiliate.name,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
      ),
      body: SafeArea(child: _buildBody(context, state, notifier)),
    );
  }

  Future<void> _onRemove(BuildContext context, AssignedHouseholdsNotifier notifier, Household household) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Remove access?',
      message: '${affiliate.name.isEmpty ? 'This member' : affiliate.name} will lose access to '
          '${household.displayName} (${household.displaySubtitle}). This action cannot be undone.',
    );
    if (!confirmed) return;
    final error = await notifier.removeAccess(household.id);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Widget _buildBody(BuildContext context, AssignedHouseholdsState state, AssignedHouseholdsNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
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

    if (state.households.isEmpty) {
      return Center(child: Text('No properties assigned yet.', style: AppTextStyles.bodySecondary));
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        itemCount: state.households.length + 1,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Text('Assigned properties', textAlign: TextAlign.center, style: AppTextStyles.pageTitle);
          }
          final household = state.households[i - 1];
          return _HouseholdTile(
            household: household,
            onRemove: () => _onRemove(context, notifier, household),
          );
        },
      ),
    );
  }
}

class _HouseholdTile extends StatelessWidget {
  final Household household;
  final VoidCallback onRemove;
  const _HouseholdTile({required this.household, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(Icons.home_work_outlined, size: 24.sp, color: AppColors.textSecondary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  household.displayName,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(household.displaySubtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Remove access',
              icon: Icon(
                Icons.close,
                size: 22.sp,
                color: AppColors.error,
              ),
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
