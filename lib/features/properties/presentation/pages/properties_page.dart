import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/home/presentation/providers/profile_summary_provider.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/presentation/providers/properties_provider.dart';
import 'package:pms_app/features/properties/presentation/widgets/property_form_fields.dart';
import 'package:pms_app/features/properties/presentation/widgets/property_summary_card.dart';

/// Matches the design's "Please specify your property" screens: step 3
/// of the multi-step flow (back arrow + dots), a summary card per
/// already-added property (Edit/Delete overflow menu), a draft form
/// below it for adding the next one, "Add property", and "Next".
///
/// Only this step's design was provided — steps 4-5 aren't specified
/// yet, so "Next" persists the list and returns to Home; chain the next
/// route here once those designs arrive.
class PropertiesPage extends ConsumerStatefulWidget {
  const PropertiesPage({super.key});

  @override
  ConsumerState<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends ConsumerState<PropertiesPage> {
  final _suiteController = TextEditingController();

  @override
  void dispose() {
    _suiteController.dispose();
    super.dispose();
  }

  Future<void> _onAddProperty() async {
    final notifier = ref.read(propertiesProvider.notifier);
    notifier.updateDraft(suite: _suiteController.text.trim());
    final ok = await notifier.addDraftAsProperty();
    if (ok) _suiteController.clear();
  }

  Future<void> _onEditProperty(Property property) async {
    await context.push(RouteNames.editProperty, extra: property);
  }

  Future<void> _onDeleteProperty(Property property) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove property?'),
        content: Text('This will remove suite # ${property.suite} from your properties.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(propertiesProvider.notifier).deleteProperty(property.id);
    }
  }

  Future<void> _onNext() async {
    ref.invalidate(profileSummaryProvider);
    context.go(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertiesProvider);
    final notifier = ref.read(propertiesProvider.notifier);

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
      currentStep: 2,
      totalSteps: 5,
      bottomButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton(
            label: 'Add property',
            isLoading: state.isSubmittingDraft,
            onPressed: _onAddProperty,
          ),
          SizedBox(height: 12.h),
          GradientButton(label: 'Next', onPressed: _onNext),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Please specify your property',
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          SizedBox(height: 12.h),
          Text(
            'Please identify the properties you own in this residency. '
            'The information you add here is shared with the system for '
            'your convenience.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 20.h),
          for (int i = 0; i < state.properties.length; i++) ...[
            PropertySummaryCard(
              property: state.properties[i],
              index: i,
              total: state.properties.length,
              residencyName: state.residencyName,
              place: state.place,
              onAction: (action) {
                switch (action) {
                  case PropertyCardAction.edit:
                    _onEditProperty(state.properties[i]);
                    break;
                  case PropertyCardAction.delete:
                    _onDeleteProperty(state.properties[i]);
                    break;
                }
              },
            ),
            SizedBox(height: 20.h),
          ],
          PropertyFormFields(
            suiteController: _suiteController,
            floor: state.draft.floor,
            type: state.draft.type,
            building: state.draft.building,
            onFloorChanged: (v) => notifier.updateDraft(floor: v),
            onTypeChanged: (v) => notifier.updateDraft(type: v),
            onBuildingChanged: (v) => notifier.updateDraft(building: v),
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
