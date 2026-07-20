import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/pets/presentation/widgets/pet_options.dart';

/// The Species/Breed/Number of pets field group shown on both the
/// add-pet form and the Edit-pet screen.
class PetFormFields extends StatelessWidget {
  final String? species;
  final TextEditingController breedController;
  final TextEditingController numberOfPetsController;
  final ValueChanged<String> onSpeciesChanged;
  final bool showValidationErrors;

  const PetFormFields({
    super.key,
    required this.species,
    required this.breedController,
    required this.numberOfPetsController,
    required this.onSpeciesChanged,
    this.showValidationErrors = false,
  });

  String? get _speciesError =>
      showValidationErrors && species == null ? 'Please select a species' : null;

  String? get _breedError =>
      showValidationErrors && breedController.text.trim().isEmpty
          ? 'Please enter a breed'
          : null;

  String? get _numberOfPetsError {
    if (!showValidationErrors) return null;
    final text = numberOfPetsController.text.trim();
    if (text.isEmpty) return 'Please enter the number of pets';
    final n = int.tryParse(text);
    if (n == null || n <= 0) return 'Please enter a valid number';
    return null;
  }

  Future<void> _pickSpecies(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: PetOptions.species,
      current: species,
      title: 'Species',
    );
    if (selected != null) onSpeciesChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledPickerField(
          label: 'Species',
          displayValue: species ?? 'Choose',
          isPlaceholder: species == null,
          errorText: _speciesError,
          onTap: () => _pickSpecies(context),
        ),
        SizedBox(height: 20.h),
        LabeledFormField(
          label: 'Breed',
          controller: breedController,
          hintText: 'Enter breed',
          errorText: _breedError,
        ),
        SizedBox(height: 20.h),
        LabeledFormField(
          label: 'Number of pets',
          controller: numberOfPetsController,
          hintText: '1',
          keyboardType: TextInputType.number,
          errorText: _numberOfPetsError,
        ),
      ],
    );
  }
}
