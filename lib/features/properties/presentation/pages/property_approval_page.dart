import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/properties/domain/entities/residency_request.dart';
import 'package:pms_app/features/properties/presentation/providers/residency_requests_provider.dart';

class PropertyApprovalPage extends ConsumerWidget {
  const PropertyApprovalPage({super.key});

  Future<void> _onContinue(BuildContext context, ResidencyRequestsState state) async {
    if (state.hasPending) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Approval pending'),
          content: const Text('Your property is still under review. You will be notified once it is approved.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
          ],
        ),
      );
      return;
    }
    context.push(RouteNames.familyMembers);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(residencyRequestsProvider);

    return StepScaffold(
      currentStep: 2,
      totalSteps: 5,
      bottomButton: GradientButton(
        label: 'Continue',
        onPressed: state.isLoading || state.error != null ? null : () => _onContinue(context, state),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Property Under Review', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 8.h),
          Text(
            'Your property details have been submitted for admin approval. You will be notified once it is approved.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 24.h),
          Center(
            child: Container(
              width: 96.w,
              height: 96.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              child: Icon(Icons.access_time, size: 44.sp, color: AppColors.primary),
            ),
          ),
          SizedBox(height: 24.h),
          _buildContent(context, ref, state),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20.sp, color: AppColors.textSecondary),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What happens next?', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                      SizedBox(height: 4.h),
                      Text(
                        'Once your property is approved, you can continue onboarding by adding your family members, vehicles and pets.',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ResidencyRequestsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null) {
      return Column(
        children: [
          Text(
            state.error!,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.error),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: ref.read(residencyRequestsProvider.notifier).load,
            child: const Text('Retry'),
          ),
        ],
      );
    }
    final request = state.current;
    if (request == null) {
      return Center(child: Text('No requests found.', style: AppTextStyles.bodySecondary));
    }
    return _RequestCard(request: request);
  }
}

class _RequestCard extends StatelessWidget {
  final ResidencyRequest request;

  const _RequestCard({required this.request});

  String get _status =>
      request.status.isEmpty ? '-' : request.status[0].toUpperCase() + request.status.substring(1).toLowerCase();

  @override
  Widget build(BuildContext context) {
    final title = request.developmentName.isNotEmpty ? request.developmentName : request.buildingName;
    final line1 = [
      if (request.suite.isNotEmpty) 'Suite ${request.suite}',
      if (request.floor.isNotEmpty) 'Floor ${request.floor}',
    ].join('  •  ');
    final line2 = [
      if (request.unitType.isNotEmpty) request.unitType,
      if (request.buildingName.isNotEmpty) 'Building ${request.buildingName}',
    ].join('  •  ');
    final pendingColor = request.isPending ? AppColors.primary : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your property', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: pendingColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(_status, style: AppTextStyles.caption.copyWith(color: pendingColor)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: AppColors.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.apartment, size: 24.sp, color: AppColors.textSecondary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    if (line1.isNotEmpty) Text(line1, style: AppTextStyles.caption),
                    if (line2.isNotEmpty) Text(line2, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
