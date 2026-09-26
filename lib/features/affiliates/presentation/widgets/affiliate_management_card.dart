import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';

enum AffiliateManagementAction { edit, delete, propertyAssignment, propertyAssigned }

class AffiliateManagementCard extends StatelessWidget {
  final Affiliate affiliate;
  final int index;
  final int total;
  final ValueChanged<AffiliateManagementAction> onAction;

  const AffiliateManagementCard({
    super.key,
    required this.affiliate,
    required this.index,
    required this.total,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _field('Name', affiliate.name.isEmpty ? '-' : affiliate.name)),
                  Expanded(child: _field('Relationship', affiliate.relationship ?? '-')),
                  Expanded(child: _field('Status', affiliate.status)),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: _field('Email', affiliate.email.isEmpty ? '-' : affiliate.email)),
                  Expanded(child: _field('Phone', affiliate.phone.isEmpty ? '-' : affiliate.phone)),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text('Family member ${index + 1} of $total', style: AppTextStyles.caption),
            const Spacer(),
            PopupMenuButton<AffiliateManagementAction>(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.more_horiz, size: 20.sp, color: AppColors.textSecondary),
              onSelected: onAction,
              itemBuilder: (context) => const [
                PopupMenuItem(
                  height: 36,
                  value: AffiliateManagementAction.edit, 
                  child: Text('Edit')
                ),
                PopupMenuItem(
                  height: 36,
                  value: AffiliateManagementAction.delete, 
                  child: Text('Delete')
                ),
                PopupMenuItem(
                  height: 36,
                  value: AffiliateManagementAction.propertyAssignment, 
                  child: Text('Property assignment')
                ),
                PopupMenuItem(
                  height: 36,
                  value: AffiliateManagementAction.propertyAssigned, 
                  child: Text('Property assigned')
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: 2.h),
        Text(value, style: AppTextStyles.body.copyWith(fontSize: 13.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
