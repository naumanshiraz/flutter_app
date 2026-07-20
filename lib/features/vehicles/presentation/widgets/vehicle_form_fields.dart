import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/vehicles/presentation/widgets/vehicle_options.dart';

class VehicleFormFields extends StatelessWidget {
  final String? type;
  final String? brand;
  final String? engineType;
  final TextEditingController licensePlateController;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onBrandChanged;
  final ValueChanged<String> onEngineTypeChanged;
  final bool showValidationErrors;

  const VehicleFormFields({
    super.key,
    required this.type,
    required this.brand,
    required this.engineType,
    required this.licensePlateController,
    required this.onTypeChanged,
    required this.onBrandChanged,
    required this.onEngineTypeChanged,
    this.showValidationErrors = false,
  });

  String? get _typeError =>
      showValidationErrors && type == null ? 'Please select a vehicle type' : null;
  String? get _brandError =>
      showValidationErrors && brand == null ? 'Please select a brand' : null;
  String? get _engineTypeError =>
      showValidationErrors && engineType == null ? 'Please select an engine type' : null;
  String? get _licensePlateError =>
      showValidationErrors && licensePlateController.text.trim().isEmpty
          ? 'Please enter a license plate number'
          : null;

  Future<void> _pickType(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context, options: VehicleOptions.types, current: type, title: 'Type',
    );
    if (selected != null) onTypeChanged(selected);
  }

  Future<void> _pickBrand(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context, options: VehicleOptions.brands, current: brand, title: 'Brand',
    );
    if (selected != null) onBrandChanged(selected);
  }

  Future<void> _pickEngineType(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context, options: VehicleOptions.engineTypes, current: engineType, title: 'Engine type',
    );
    if (selected != null) onEngineTypeChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledPickerField(
          label: 'Type',
          displayValue: type ?? 'Choose',
          isPlaceholder: type == null,
          errorText: _typeError,
          onTap: () => _pickType(context),
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Brand',
          displayValue: brand ?? 'Choose',
          isPlaceholder: brand == null,
          errorText: _brandError,
          onTap: () => _pickBrand(context),
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Engine type',
          displayValue: engineType ?? 'Choose',
          isPlaceholder: engineType == null,
          errorText: _engineTypeError,
          onTap: () => _pickEngineType(context),
        ),
        SizedBox(height: 20.h),
        LabeledFormField(
          label: 'License plate number',
          controller: licensePlateController,
          hintText: 'Enter license plate number',
          errorText: _licensePlateError,
        ),
      ],
    );
  }
}
