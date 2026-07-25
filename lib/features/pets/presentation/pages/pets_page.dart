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
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/presentation/providers/pets_provider.dart';
import 'package:pms_app/features/pets/presentation/widgets/pet_form_fields.dart';
import 'package:pms_app/features/pets/presentation/widgets/pet_summary_card.dart';

class PetsPage extends ConsumerStatefulWidget {
  const PetsPage({super.key});

  @override
  ConsumerState<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends ConsumerState<PetsPage> {
  final _breedController = TextEditingController();
  final _numberOfPetsController = TextEditingController();
  bool _showValidationErrors = false;

  @override
  void dispose() {
    _breedController.dispose();
    _numberOfPetsController.dispose();
    super.dispose();
  }

  Future<void> _onAddPet() async {
    setState(() => _showValidationErrors = true);
    final notifier = ref.read(petsProvider.notifier);
    notifier.updateDraft(
      breed: _breedController.text.trim(),
      numberOfPets: _numberOfPetsController.text.trim(),
    );
    final ok = await notifier.addDraftAsPet();
    if (ok) {
      setState(() => _showValidationErrors = false);
      _breedController.clear();
      _numberOfPetsController.clear();
    }
  }

  Future<void> _onEditPet(Pet pet) async {
    await context.push(RouteNames.editPet, extra: pet);
  }

  Future<void> _onDeletePet(Pet pet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove pet?'),
        content: Text('This will remove ${pet.species ?? 'this pet'} from your list.'),
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
      await ref.read(petsProvider.notifier).deletePet(pet.id);
    }
  }

  Future<void> _onNext() async {
    final accepted = await context.push<bool>(RouteNames.residencyTerms);

    if (accepted == true) {
      ref.invalidate(profileSummaryProvider);
      context.go(RouteNames.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the agreement to proceed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(petsProvider);
    final notifier = ref.read(petsProvider.notifier);

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
      currentStep: 4,
      totalSteps: 5,
      bottomButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton(
            label: 'Add pet',
            isLoading: state.isSubmittingDraft,
            onPressed: _onAddPet,
          ),
          SizedBox(height: 12.h),
          GradientButton(label: 'Next', onPressed: _onNext),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Do you have any pets?',
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          SizedBox(height: 12.h),
          Text(
            'Please note that you only need to include your pets in this property.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 20.h),
          for (int i = 0; i < state.pets.length; i++) ...[
            PetSummaryCard(
              pet: state.pets[i],
              index: i,
              total: state.pets.length,
              onAction: (action) {
                switch (action) {
                  case PetCardAction.edit:
                    _onEditPet(state.pets[i]);
                    break;
                  case PetCardAction.delete:
                    _onDeletePet(state.pets[i]);
                    break;
                }
              },
            ),
            SizedBox(height: 20.h),
          ],
          PetFormFields(
            species: state.draft.species,
            breedController: _breedController,
            numberOfPetsController: _numberOfPetsController,
            onSpeciesChanged: (v) => notifier.updateDraft(species: v),
            showValidationErrors: _showValidationErrors,
          ),
          if (state.errorMessage != null) ...[
            SizedBox(height: 12.h),
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
