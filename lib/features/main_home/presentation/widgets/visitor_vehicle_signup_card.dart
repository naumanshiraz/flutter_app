import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';
import 'package:pms_app/features/main_home/presentation/widgets/set_up_schedule_sheet.dart';
import 'package:pms_app/features/main_home/presentation/providers/visitor_provider.dart';

enum VisitorAction { edit, delete }

class VisitorVehicleSignupCard extends ConsumerWidget {
  const VisitorVehicleSignupCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(visitorNotifierProvider);
    final notifier = ref.read(visitorNotifierProvider.notifier);

    final has = state.schedules.isNotEmpty;
    final first = has ? state.schedules.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Visitor vehicle sign-up',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration:
          BoxDecoration(color: AppColors.border.withOpacity(0.35), borderRadius: BorderRadius.circular(10.r)),
          child: has
              ? Column(
            children: [
              Row(
                children: [
                  Expanded(child: _InfoItem(title: 'License plate number', value: first!.licensePlate)),
                  Expanded(child: _InfoItem(title: 'Guest name', value: first.guestName)),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: _InfoItem(title: 'Expected time of arrival', value: first.time)),
                  Expanded(child: _InfoItem(title: 'Date', value: first.date)),
                ],
              ),
            ],
          )
              : SizedBox(
            height: 96.h,
            child: const Center(child: Text('No visitor schedules')),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: Text(has ? 'Visitor schedule 1 of ${state.schedules.length}' : 'No schedules',
                  style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
            ),
            if (has)
              PopupMenuButton<VisitorAction>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_horiz, size: 18.sp, color: AppColors.textSecondary),
                onSelected: (action) async {
                  if (action == VisitorAction.edit && first != null) {
                    final updated = await _openScheduleSheet(context, initial: first);
                    if (updated != null) {
                      await notifier.addOrUpdate(updated);
                    }
                  } else if (action == VisitorAction.delete && first != null) {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Delete schedule?'),
                        content: const Text('Are you sure you want to delete this schedule?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete')),
                        ],
                      ),
                    );
                    if (ok == true) await notifier.delete(first.id);
                  }
                },
                itemBuilder: (c) => const [
                  PopupMenuItem(value: VisitorAction.edit, child: Text('Edit')),
                  PopupMenuItem(value: VisitorAction.delete, child: Text('Delete')),
                ],
              )
            else
              IconButton(
                onPressed: () async {
                  final created = await _openScheduleSheet(context);
                  if (created != null) await notifier.addOrUpdate(created);
                },
                icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () async {
              final created = await _openScheduleSheet(context);
              if (created != null) await notifier.addOrUpdate(created);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Text('Set up a new schedule',
                style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Future<VisitorSchedule?> _openScheduleSheet(
    BuildContext context, {
      VisitorSchedule? initial,
    }) {
    return showModalBottomSheet<VisitorSchedule>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SetUpScheduleSheet(initial: initial),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;
  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTextStyles.caption),
      SizedBox(height: 6.h),
      Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
    ]);
  }
}