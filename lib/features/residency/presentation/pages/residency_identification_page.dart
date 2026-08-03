import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/residency/presentation/providers/residency_form_provider.dart';

class ResidencyIdentificationPage extends ConsumerWidget {
  const ResidencyIdentificationPage({super.key});

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required List<String> options,
    required String? current,
    required ValueChanged<String> onSelected,
  }) async {
    if (options.isEmpty) return;
    final selected = await SingleSelectSheet.show(
      context,
      options: options,
      current: current,
      title: title,
    );
    if (selected != null) onSelected(selected);
  }

  Future<void> _onNext(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(residencyFormProvider.notifier);
    final ok = await notifier.save();
    if (!ok || !context.mounted) return;

    // Continue the multi-step flow into the next provided design
    // (Family Members / affiliates) rather than returning to Home.
    context.push(RouteNames.familyMembers);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(residencyFormProvider);
    final notifier = ref.read(residencyFormProvider.notifier);
    final address = state.address;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      );
    }

    return StepScaffold(
      currentStep: 0,
      totalSteps: 5,
      bottomButton: GradientButton(
        label: 'Next',
        isLoading: state.isSaving,
        onPressed: address.isComplete ? () => _onNext(context, ref) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Please identify your residency',
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          SizedBox(height: 12.h),
          Text(
            'Keep your personal details private. Information you add here '
            'is shared to authorities of your property management '
            'organization or company.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 28.h),
          LabeledPickerField(
            label: 'Country',
            displayValue: address.country ?? 'Choose',
            isPlaceholder: address.country == null,
            onTap: () => _pick(
              context,
              ref,
              title: 'Country',
              options: notifier.countryOptions(),
              current: address.country,
              onSelected: notifier.selectCountry,
            ),
          ),
          SizedBox(height: 20.h),
          LabeledPickerField(
            label: 'City',
            displayValue: address.city ?? 'Choose',
            isPlaceholder: address.city == null,
            onTap: () => _pick(
              context,
              ref,
              title: 'City',
              options: notifier.cityOptions(),
              current: address.city,
              onSelected: notifier.selectCity,
            ),
          ),
          SizedBox(height: 20.h),
          LabeledPickerField(
            label: 'District',
            displayValue: address.district ?? 'Choose',
            isPlaceholder: address.district == null,
            onTap: () => _pick(
              context,
              ref,
              title: 'District',
              options: notifier.districtOptions(),
              current: address.district,
              onSelected: notifier.selectDistrict,
            ),
          ),
          SizedBox(height: 20.h),
          LabeledPickerField(
            label: 'Khoroo',
            displayValue: address.khoroo ?? 'Choose',
            isPlaceholder: address.khoroo == null,
            onTap: () => _pick(
              context,
              ref,
              title: 'Khoroo',
              options: notifier.khorooOptions(),
              current: address.khoroo,
              onSelected: notifier.selectKhoroo,
            ),
          ),
          SizedBox(height: 20.h),
          LabeledPickerField(
            label: 'Residence',
            displayValue: address.residence ?? 'Choose',
            isPlaceholder: address.residence == null,
            onTap: () => _pick(
              context,
              ref,
              title: 'Residence',
              options: notifier.residenceOptions(),
              current: address.residence,
              onSelected: notifier.selectResidence,
            ),
          ),
          if (state.errorMessage != null) ...[
            SizedBox(height: 16.h),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }
}
