import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/properties/presentation/widgets/property_options.dart';

class PropertyFormFields extends StatelessWidget {
  final TextEditingController suiteController;
  final String? floor;
  final String? type;
  final String? building;
  final ValueChanged<String> onFloorChanged;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onBuildingChanged;

  const PropertyFormFields({
    super.key,
    required this.suiteController,
    required this.floor,
    required this.type,
    required this.building,
    required this.onFloorChanged,
    required this.onTypeChanged,
    required this.onBuildingChanged,
  });

  Future<void> _pickFloor(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: PropertyOptions.floors(),
      current: floor,
      title: 'Floor',
    );
    if (selected != null) onFloorChanged(selected);
  }

  Future<void> _pickType(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: PropertyOptions.types,
      current: type,
      title: 'Type',
    );
    if (selected != null) onTypeChanged(selected);
  }

  Future<void> _pickBuilding(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: PropertyOptions.buildings,
      current: building,
      title: 'Building',
    );
    if (selected != null) onBuildingChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledFormField(
          label: 'Suite',
          controller: suiteController,
          hintText: 'Enter suite number',
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Floor',
          displayValue: floor ?? 'Choose',
          isPlaceholder: floor == null,
          onTap: () => _pickFloor(context),
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Type',
          displayValue: type ?? 'Choose',
          isPlaceholder: type == null,
          onTap: () => _pickType(context),
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Building',
          displayValue: building ?? 'Choose',
          isPlaceholder: building == null,
          onTap: () => _pickBuilding(context),
        ),
      ],
    );
  }
}
