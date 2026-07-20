import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:pms_app/features/vehicles/presentation/widgets/vehicle_form_fields.dart';
import 'package:pms_app/features/vehicles/presentation/widgets/vehicle_summary_card.dart';

/// Matches the design's "Please share details of your vehicles"
/// screens: step 4 of the multi-step flow (back arrow + dots), a
/// summary card per already-added vehicle (Edit/Delete overflow menu),
/// a draft form below it for adding the next one, "Add vehicle", and
/// "Next".
///
/// Only this step's design was provided — step 5 isn't specified yet,
/// so "Next" persists the list and returns to Home; chain the final
/// route here once that design arrives.
class VehiclesPage extends ConsumerStatefulWidget {
  const VehiclesPage({super.key});

  @override
  ConsumerState<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends ConsumerState<VehiclesPage> {
  final _licensePlateController = TextEditingController();
  bool _showValidationErrors = false;

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  Future<void> _onAddVehicle() async {
    setState(() => _showValidationErrors = true);
    final notifier = ref.read(vehiclesProvider.notifier);
    notifier.updateDraft(licensePlate: _licensePlateController.text.trim());
    final ok = await notifier.addDraftAsVehicle();
    if (ok) {
      setState(() => _showValidationErrors = false);
      _licensePlateController.clear();
    }
  }

  Future<void> _onEditVehicle(Vehicle vehicle) async {
    await context.push(RouteNames.editVehicle, extra: vehicle);
  }

  Future<void> _onDeleteVehicle(Vehicle vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove vehicle?'),
        content: Text('This will remove ${vehicle.licensePlate} from your vehicles.'),
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
      await ref.read(vehiclesProvider.notifier).deleteVehicle(vehicle.id);
    }
  }

  Future<void> _onNext() async {
    context.push(RouteNames.pets);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehiclesProvider);
    final notifier = ref.read(vehiclesProvider.notifier);

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
      currentStep: 3,
      totalSteps: 5,
      bottomButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton(
            label: 'Add vehicle',
            isLoading: state.isSubmittingDraft,
            onPressed: _onAddVehicle,
          ),
          SizedBox(height: 12.h),
          GradientButton(label: 'Next', onPressed: _onNext),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Please share details of your vehicles',
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          SizedBox(height: 12.h),
          Text(
            'Please let us know the details of your vehicles. Your '
            'contribution is vital to our property management system for '
            'maintaining your convenience.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 20.h),
          for (int i = 0; i < state.vehicles.length; i++) ...[
            VehicleSummaryCard(
              vehicle: state.vehicles[i],
              index: i,
              total: state.vehicles.length,
              onAction: (action) {
                switch (action) {
                  case VehicleCardAction.edit:
                    _onEditVehicle(state.vehicles[i]);
                    break;
                  case VehicleCardAction.delete:
                    _onDeleteVehicle(state.vehicles[i]);
                    break;
                }
              },
            ),
            SizedBox(height: 20.h),
          ],
          VehicleFormFields(
            type: state.draft.type,
            brand: state.draft.brand,
            engineType: state.draft.engineType,
            licensePlateController: _licensePlateController,
            onTypeChanged: (v) => notifier.updateDraft(type: v),
            onBrandChanged: (v) => notifier.updateDraft(brand: v),
            onEngineTypeChanged: (v) => notifier.updateDraft(engineType: v),
            showValidationErrors: _showValidationErrors,
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
