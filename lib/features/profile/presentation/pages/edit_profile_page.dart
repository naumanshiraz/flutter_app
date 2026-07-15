import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:pms_app/features/profile/presentation/widgets/profile_avatar_circle.dart';

/// Matches the PDF exactly: X to close (discards unsaved changes),
/// checkmark to save, tappable avatar (routes to
/// [ProfilePicturePage]), and the Name/Email/Phone number/Country/
/// Birthdate/Pronouns fields.
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _pronounsController;

  bool _controllersHydrated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _pronounsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pronounsController.dispose();
    super.dispose();
  }

  /// Fills the text controllers from loaded state exactly once — after
  /// that the controllers are the source of truth for typed text, and
  /// only explicit picker fields (country/birthdate) write back into
  /// provider state directly.
  void _hydrateControllersIfNeeded(EditProfileState state) {
    if (_controllersHydrated || state.status == EditProfileStatus.loading) return;
    _nameController.text = state.profile.name;
    _emailController.text = state.profile.email;
    _phoneController.text = state.profile.phone;
    _pronounsController.text = state.profile.pronouns ?? '';
    _controllersHydrated = true;
  }

  Future<void> _pickBirthDate(BuildContext context) async {
    final current = ref.read(editProfileProvider).profile.birthDate;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(now.year - 30, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );
    if (picked != null) {
      ref.read(editProfileProvider.notifier).updateFields(birthDate: picked);
    }
  }

  Future<void> _pickCountry(BuildContext context) async {
    final selected = await SingleSelectSheet.show(
      context,
      options: _kCountries,
      current: ref.read(editProfileProvider).profile.country,
    );
    if (selected != null) {
      ref.read(editProfileProvider.notifier).updateFields(country: selected);
    }
  }

  Future<void> _onSave() async {
    // Push whatever's currently typed into the controllers into state
    // before saving, so the notifier validates/persists the latest text.
    ref.read(editProfileProvider.notifier).updateFields(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          pronouns: _pronounsController.text.trim(),
        );

    final ok = await ref.read(editProfileProvider.notifier).save();
    // On success, continue forward into the Residency Identification
    // step rather than popping — X still discards and pops back to
    // Home directly; the checkmark advances the flow.
    if (ok && mounted) context.push(RouteNames.residencyIdentification);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileProvider);
    _hydrateControllersIfNeeded(state);

    final isBusy = state.status == EditProfileStatus.loading ||
        state.status == EditProfileStatus.saving;

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
                      'Edit profile',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp),
                    ),
                  ),
                  IconButton(
                    icon: state.status == EditProfileStatus.saving
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          )
                        : const Icon(Icons.check, color: AppColors.textPrimary),
                    onPressed: isBusy ? null : _onSave,
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
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push(RouteNames.profilePicture),
                        child: ProfileAvatarCircle(
                          avatarPath: state.profile.avatarPath,
                          initials: state.profile.initials,
                          size: 140,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Please update your profile',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 19.sp),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Keep your personal details private. Information you add here '
                      'is shared to authorities of your property management '
                      'organization or company.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: 28.h),
                    LabeledFormField(
                      label: 'Name',
                      controller: _nameController,
                      hintText: 'Enter your name',
                    ),
                    SizedBox(height: 20.h),
                    LabeledFormField(
                      label: 'Email',
                      controller: _emailController,
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h),
                    LabeledFormField(
                      label: 'Phone number',
                      controller: _phoneController,
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20.h),
                    LabeledPickerField(
                      label: 'Country',
                      displayValue: state.profile.country ?? 'Choose',
                      isPlaceholder: state.profile.country == null,
                      onTap: () => _pickCountry(context),
                    ),
                    SizedBox(height: 20.h),
                    LabeledPickerField(
                      label: 'Birthdate',
                      displayValue: state.profile.birthDate == null
                          ? 'Choose'
                          : DateFormat.yMMMd().format(state.profile.birthDate!),
                      isPlaceholder: state.profile.birthDate == null,
                      onTap: () => _pickBirthDate(context),
                    ),
                    SizedBox(height: 20.h),
                    LabeledFormField(
                      label: 'Pronouns',
                      controller: _pronounsController,
                      hintText: 'e.g. she/her, he/him, they/them',
                    ),
                    if (state.errorMessage != null) ...[
                      SizedBox(height: 16.h),
                      Text(
                        state.errorMessage!,
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

/// Small static country list for now — no backend/places API yet.
/// Swap for a real country lookup once one exists.
const List<String> _kCountries = [
  'Mongolia',
  'United States',
  'United Kingdom',
  'Canada',
  'Australia',
  'Pakistan',
  'United Arab Emirates',
  'Other',
];
