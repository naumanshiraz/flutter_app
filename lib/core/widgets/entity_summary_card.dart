import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

enum EntitySummaryCardAction { edit, delete }

/// A single label/value pair shown inside the card, with an optional
/// [flex] so callers can make some fields wider than others within a
/// row (e.g. "Name" gets more room than "Gender").
class SummaryField {
  final String label;
  final String value;
  final int flex;

  const SummaryField({required this.label, required this.value, this.flex = 1});
}

/// Shared visual shell for the "added item" summary cards across
/// Family Members, Properties, and Vehicles: a grey rounded card of
/// label/value field rows, followed *below* the card by an
/// "{itemLabel} X of N" caption and an Edit/Delete overflow menu —
/// matching the design exactly (the count + menu row is NOT inside the
/// card).
class EntitySummaryCard extends StatelessWidget {
  final List<List<SummaryField>> rows;
  final String itemLabel;
  final int index;
  final int total;
  final ValueChanged<EntitySummaryCardAction> onAction;

  const EntitySummaryCard({
    super.key,
    required this.rows,
    required this.itemLabel,
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
            color: AppColors.border.withOpacity(0.35),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < rows.length; i++) ...[
                if (i > 0) SizedBox(height: 10.h),
                Row(
                  children: rows[i]
                      .map((field) => Expanded(
                            flex: field.flex,
                            child: _Field(label: field.label, value: field.value),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text('$itemLabel ${index + 1} of $total', style: AppTextStyles.caption),
            const Spacer(),
            PopupMenuButton<EntitySummaryCardAction>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_horiz, size: 20.sp, color: AppColors.textSecondary),
              onSelected: onAction,
              itemBuilder: (context) => const [
                PopupMenuItem(value: EntitySummaryCardAction.edit, child: Text('Edit')),
                PopupMenuItem(value: EntitySummaryCardAction.delete, child: Text('Delete')),
              ],
            ),
          ],
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
