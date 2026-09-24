import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/affiliates/presentation/utils/affiliate_validators.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_options.dart';

class AffiliateFormFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController contactController;
  final String? relationship;
  final ValueChanged<String> onRelationshipChanged;

  /// Set true (e.g. right before submit) to force-show validation errors.
  final bool showErrors;

  const AffiliateFormFields({
    super.key,
    required this.nameController,
    required this.contactController,
    required this.relationship,
    required this.onRelationshipChanged,
    this.showErrors = false,
  });

  @override
  State<AffiliateFormFields> createState() => AffiliateFormFieldsState();
}

class AffiliateFormFieldsState extends State<AffiliateFormFields> {
  Future<void> _pickRelationship() async {
    final selected = await SingleSelectSheet.show(
      context,
      options: AffiliateOptions.relationships,
      current: widget.relationship,
      title: 'Relationship',
    );
    if (selected != null) widget.onRelationshipChanged(selected);
  }

  /// Returns the first validation error, if any, for external callers
  /// (e.g. the submit button) that want to short-circuit before saving.
  String? validate() {
    return AffiliateValidators.validateDraft(
      name: widget.nameController.text,
      contact: widget.contactController.text,
      relationship: widget.relationship,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameError = widget.showErrors ? AffiliateValidators.nameError(widget.nameController.text) : null;
    final contactError = widget.showErrors ? AffiliateValidators.contactError(widget.contactController.text) : null;
    final relationshipError = widget.showErrors ? AffiliateValidators.relationshipError(widget.relationship) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledFormField(
          label: 'Name',
          controller: widget.nameController,
          hintText: 'Enter full name',
          errorText: nameError,
        ),
        SizedBox(height: 20.h),
        LabeledFormField(
          label: 'Email or phone number',
          controller: widget.contactController,
          hintText: 'Enter email or phone number',
          errorText: contactError,
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Relationship',
          displayValue: widget.relationship ?? 'Choose',
          isPlaceholder: widget.relationship == null,
          onTap: _pickRelationship,
          errorText: relationshipError,
        ),
      ],
    );
  }
}
