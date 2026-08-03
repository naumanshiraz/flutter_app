import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/family_members/presentation/widgets/family_member_options.dart';

class FamilyMemberFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String? relationship;
  final int? birthYear;
  final String? gender;
  final ValueChanged<String> onRelationshipChanged;
  final ValueChanged<int> onBirthYearChanged;
  final ValueChanged<String> onGenderChanged;

  const FamilyMemberFormFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.relationship,
    required this.birthYear,
    required this.gender,
    required this.onRelationshipChanged,
    required this.onBirthYearChanged,
    required this.onGenderChanged,
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

  Future<void> _pickBirthYear(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: FamilyMemberOptions.birthYears(),
      current: birthYear?.toString(),
      title: 'Birth year',
    );
    if (selected != null) onBirthYearChanged(int.parse(selected));
  }

  Future<void> _pickGender(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: FamilyMemberOptions.genders,
      current: gender,
      title: 'Gender',
    );
    if (selected != null) onGenderChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledFormField(label: 'Name', controller: nameController, hintText: 'Enter full name'),
        SizedBox(height: 20.h),
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
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Birth year',
          displayValue: birthYear?.toString() ?? 'Choose',
          isPlaceholder: birthYear == null,
          onTap: () => _pickBirthYear(context),
        ),
        SizedBox(height: 20.h),
        LabeledPickerField(
          label: 'Gender',
          displayValue: gender ?? 'Choose',
          isPlaceholder: gender == null,
          onTap: () => _pickGender(context),
        ),
      ],
    );
  }
}
