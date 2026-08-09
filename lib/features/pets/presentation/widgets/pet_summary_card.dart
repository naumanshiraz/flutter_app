import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';

enum PetCardAction { edit, delete }

class PetSummaryCard extends StatelessWidget {
  final Pet pet;
  final int index;
  final int total;
  final ValueChanged<PetCardAction> onAction;

  const PetSummaryCard({
    super.key,
    required this.pet,
    required this.index,
    required this.total,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Grey container first ---
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
                  Expanded(child: _Field(label: 'Species', value: pet.species ?? '-')),
                  Expanded(child: _Field(label: 'Number of pets', value: pet.numberOfPets)),
                ],
              ),
              SizedBox(height: 10.h),
              _Field(label: 'Breed', value: pet.breed),
            ],
          ),
        ),
        // --- Label + ⋮ menu BELOW the container ---
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pets ${index + 1} of $total',
              style: AppTextStyles.caption,
            ),
            PopupMenuButton<PetCardAction>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_horiz, size: 18.sp, color: AppColors.textSecondary),
              onSelected: onAction,
              itemBuilder: (context) => const [
                PopupMenuItem(value: PetCardAction.edit, child: Text('Edit')),
                PopupMenuItem(value: PetCardAction.delete, child: Text('Delete')),
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
