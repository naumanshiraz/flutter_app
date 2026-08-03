import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';
import 'package:pms_app/features/vehicles/presentation/providers/vehicles_provider.dart';
import 'package:pms_app/features/vehicles/presentation/widgets/vehicle_form_fields.dart';

class EditVehiclePage extends ConsumerStatefulWidget {
  final Vehicle vehicle;

  const EditVehiclePage({super.key, required this.vehicle});

  @override
  ConsumerState<EditVehiclePage> createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends ConsumerState<EditVehiclePage> {
  late final TextEditingController _licensePlateController;
  late String? _type;
  late String? _brand;
  late String? _engineType;

  bool _isSaving = false;
  bool _showValidationErrors = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _licensePlateController = TextEditingController(text: widget.vehicle.licensePlate);
    _type = widget.vehicle.type;
    _brand = widget.vehicle.brand;
    _engineType = widget.vehicle.engineType;
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _showValidationErrors = true);
    final updated = widget.vehicle.copyWith(
      type: _type,
      brand: _brand,
      engineType: _engineType,
      licensePlate: _licensePlateController.text.trim(),
    );

    if (!updated.isValid) {
      setState(() => _errorMessage = 'Please complete every field.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final ok = await ref.read(vehiclesProvider.notifier).updateVehicle(updated);

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = ref.read(vehiclesProvider).errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Edit',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp),
                    ),
                  ),
                  IconButton(
                    icon: _isSaving
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          )
                        : const Icon(Icons.check, color: AppColors.textPrimary),
                    onPressed: _isSaving ? null : _onSave,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please let us know the details of your vehicles. '
                      'Your contribution is vital to our property '
                      'management system for maintaining your convenience.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: 24.h),
                    VehicleFormFields(
                      type: _type,
                      brand: _brand,
                      engineType: _engineType,
                      licensePlateController: _licensePlateController,
                      onTypeChanged: (v) => setState(() => _type = v),
                      onBrandChanged: (v) => setState(() => _brand = v),
                      onEngineTypeChanged: (v) => setState(() => _engineType = v),
                      showValidationErrors: _showValidationErrors,
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 16.h),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(color: AppColors.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Defensive fallback for the (unlikely) case someone deep-links to the
/// edit route without a vehicle in `state.extra`.
class EditVehicleFallbackPage extends StatelessWidget {
  const EditVehicleFallbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Edit Vehicle',
      routeName: RouteNames.editVehicle,
    );
  }
}
