import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/presentation/widgets/property_options.dart';

enum PropertyCardAction { edit, delete }

/// Matches the design's "Property X of N" summary card exactly:
/// Suite / Floor / Residency on the top row, Building / Type / Place on
/// the bottom row (Residency + Place come from the Residency
/// Identification step, not this form), plus an Edit/Delete overflow
/// menu.
class PropertySummaryCard extends StatelessWidget {
  final Property property;
  final int index;
  final int total;
  final String residencyName;
  final String place;
  final ValueChanged<PropertyCardAction> onAction;

  const PropertySummaryCard({
    super.key,
    required this.property,
    required this.index,
    required this.total,
    required this.residencyName,
    required this.place,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final floorDisplay = property.floor == null ? '-' : PropertyOptions.ordinal(property.floor!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Property ${index + 1} of $total', style: AppTextStyles.caption),
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
                        Expanded(child: _Field(label: 'Suite', value: '# ${property.suite}')),
                        Expanded(child: _Field(label: 'Floor', value: floorDisplay)),
                        Expanded(
                          child: _Field(
                            label: 'Residency',
                            value: residencyName.isEmpty ? '-' : residencyName,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<PropertyCardAction>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_vert, size: 20.sp, color: AppColors.textSecondary),
                    onSelected: onAction,
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: PropertyCardAction.edit, child: Text('Edit')),
                      PopupMenuItem(value: PropertyCardAction.delete, child: Text('Delete')),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: _Field(label: 'Building', value: property.building ?? '-')),
                  Expanded(child: _Field(label: 'Type', value: property.type ?? '-')),
                  Expanded(
                    flex: 2,
                    child: _Field(label: 'Place', value: place.isEmpty ? '-' : place),
                  ),
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
