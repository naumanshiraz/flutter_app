import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';

enum FamilyMemberCardAction { edit, delete }

/// Matches the design's "Family member X of N" summary card: name,
/// relationship, birth year up top, contact details below, and an
/// overflow (⋮) menu offering Edit / Delete.
class FamilyMemberSummaryCard extends StatelessWidget {
  final FamilyMember member;
  final int index;
  final int total;
  final ValueChanged<FamilyMemberCardAction> onAction;

  const FamilyMemberSummaryCard({
    super.key,
    required this.member,
    required this.index,
    required this.total,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family member ${index + 1} of $total',
          style: AppTextStyles.caption,
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.border.withOpacity(0.35),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _Field(label: 'Name', value: member.name),
                        ),
                        Expanded(
                          child: _Field(label: 'Relationship', value: member.relationship ?? '-'),
                        ),
                        Expanded(
                          child: _Field(
                            label: 'Year of birth',
                            value: member.birthYear?.toString() ?? '-',
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<FamilyMemberCardAction>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert, size: 20.sp, color: AppColors.textSecondary),
                    onSelected: onAction,
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: FamilyMemberCardAction.edit, child: Text('Edit')),
                      PopupMenuItem(value: FamilyMemberCardAction.delete, child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(flex: 2, child: _Field(label: 'Email', value: member.email)),
                  Expanded(child: _Field(label: 'Phone', value: member.phone)),
                  Expanded(child: _Field(label: 'Gender', value: member.gender ?? '-')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: 2.h),
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontSize: 13.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
