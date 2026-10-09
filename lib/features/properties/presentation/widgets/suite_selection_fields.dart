import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';

class SuiteSelectionFields extends StatefulWidget {
  final List<AvailableSuite> suites;
  final AvailableSuite? selected;
  final ValueChanged<AvailableSuite> onSuiteChanged;

  const SuiteSelectionFields({
    super.key,
    required this.suites,
    required this.selected,
    required this.onSuiteChanged,
  });

  @override
  State<SuiteSelectionFields> createState() => _SuiteSelectionFieldsState();
}

class _SuiteSelectionFieldsState extends State<SuiteSelectionFields> {
  final _floor = TextEditingController();
  final _type = TextEditingController();
  final _building = TextEditingController();

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant SuiteSelectionFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    _floor.text = widget.selected?.floor ?? '';
    _type.text = widget.selected?.unitType ?? '';
    _building.text = widget.selected?.buildingName ?? '';
  }

  @override
  void dispose() {
    _floor.dispose();
    _type.dispose();
    _building.dispose();
    super.dispose();
  }

  String _label(AvailableSuite s) {
    final duplicated = widget.suites.where((o) => o.suite == s.suite).length > 1;
    return duplicated ? '${s.suite} (${s.buildingName})' : s.suite;
  }

  Future<void> _pickSuite() async {
    final labels = widget.suites.map(_label).toList();
    final selected = await SingleSelectSheet.show(
      context,
      options: labels,
      current: widget.selected == null ? null : _label(widget.selected!),
      title: 'Suite',
    );
    if (selected == null) return;
    final index = labels.indexOf(selected);
    if (index >= 0) widget.onSuiteChanged(widget.suites[index]);
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledPickerField(
          label: 'Suite',
          displayValue: selected == null ? 'Choose' : _label(selected),
          isPlaceholder: selected == null,
          onTap: _pickSuite,
        ),
        SizedBox(height: 20.h),
        LabeledFormField(label: 'Floor', controller: _floor, hintText: 'Floor', enabled: false),
        SizedBox(height: 20.h),
        LabeledFormField(label: 'Type', controller: _type, hintText: 'Type', enabled: false),
        SizedBox(height: 20.h),
        LabeledFormField(label: 'Building', controller: _building, hintText: 'Building', enabled: false),
      ],
    );
  }
}
