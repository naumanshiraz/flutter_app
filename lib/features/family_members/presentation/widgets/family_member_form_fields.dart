import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/family_members/presentation/widgets/family_member_options.dart';

class FamilyMemberFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? relationship;
  final ValueChanged<String> onRelationshipChanged;

  const FamilyMemberFormFields({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.relationship,
    required this.onRelationshipChanged,
  });

  Future<void> _pickRelationship(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: FamilyMemberOptions.relationships,
      current: relationship,
      title: 'Relationship',
    );
    if (selected != null) onRelationshipChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledFormField(
          label: 'Email',
          controller: emailController,
          hintText: 'Enter email address',
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20.h),
        LabeledFormField(
          label: 'Phone number',
          controller: phoneController,
          hintText: 'Enter phone number',
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Relationship',
          displayValue: relationship ?? 'Choose',
          isPlaceholder: relationship == null,
          onTap: () => _pickRelationship(context),
        ),
      ],
    );
  }
}
