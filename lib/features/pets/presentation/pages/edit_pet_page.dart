import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/pets/domain/entities/pet.dart';
import 'package:pms_app/features/pets/presentation/providers/pets_provider.dart';
import 'package:pms_app/features/pets/presentation/widgets/pet_form_fields.dart';

class EditPetPage extends ConsumerStatefulWidget {
  final Pet pet;
  const EditPetPage({super.key, required this.pet});

  @override
  ConsumerState<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends ConsumerState<EditPetPage> {
  late final TextEditingController _breedController;
  late final TextEditingController _numberOfPetsController;
  late String? _species;

  bool _isSaving = false;
  bool _showValidationErrors = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _breedController = TextEditingController(text: widget.pet.breed);
    _numberOfPetsController = TextEditingController(text: widget.pet.numberOfPets);
    _species = widget.pet.species;
  }

  @override
  void dispose() {
    _breedController.dispose();
    _numberOfPetsController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _showValidationErrors = true);

    final updated = widget.pet.copyWith(
      species: _species,
      breed: _breedController.text.trim(),
      numberOfPets: _numberOfPetsController.text.trim(),
    );

    if (!updated.isValid) {
      setState(() => _errorMessage = 'Please complete every field.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final ok = await ref.read(petsProvider.notifier).updatePet(updated);

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = ref.read(petsProvider).errorMessage;
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
                      'Please note that you only need to include your pets in this property.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: 24.h),
                    PetFormFields(
                      species: _species,
                      breedController: _breedController,
                      numberOfPetsController: _numberOfPetsController,
                      onSpeciesChanged: (v) => setState(() => _species = v),
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

class EditPetFallbackPage extends StatelessWidget {
  const EditPetFallbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(title: 'Edit Pet', routeName: RouteNames.editPet);
  }
}
