import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/svg_icons.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/profile/presentation/providers/edit_profile_provider.dart';
import 'package:pms_app/features/profile/presentation/widgets/profile_avatar_circle.dart';

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
  final Map<String, String> _fieldErrors = {};

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
      setState(() => _fieldErrors.remove('birthDate'));
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
      setState(() => _fieldErrors.remove('country'));
    }
  }

  bool _validate() {
    final state = ref.read(editProfileProvider);
    final errors = <String, String>{};

    if (_nameController.text.trim().isEmpty) errors['name'] = 'Please enter your name.';
    if (_emailController.text.trim().isEmpty) errors['email'] = 'Please enter your email address.';
    if (_phoneController.text.trim().isEmpty) errors['phone'] = 'Please enter your phone number.';
    if (state.profile.country == null || state.profile.country!.isEmpty) {
      errors['country'] = 'Please choose your country.';
    }
    if (state.profile.birthDate == null) errors['birthDate'] = 'Please choose your birthdate.';
    if (_pronounsController.text.trim().isEmpty) errors['pronouns'] = 'Please enter your pronouns.';

    setState(() => _fieldErrors
      ..clear()
      ..addAll(errors));
    return errors.isEmpty;
  }

  Future<void> _onSave() async {
    // TEMP: validation + PATCH /api/app/profile disabled so the residency
    // screen can be tested standalone. Restore _validate() + save() below
    // before shipping.
    if (mounted) context.push(RouteNames.residencyIdentification);
    return;
    if (!_validate()) return;

    ref.read(editProfileProvider.notifier).updateFields(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          pronouns: _pronounsController.text.trim(),
        );

    final ok = await ref.read(editProfileProvider.notifier).save();

    if (ok && mounted) context.push(RouteNames.residencyIdentification);
  }

  Future<void> _confirmChangeContact(BuildContext context, {required String field}) async {
    final label = field == 'email' ? 'email address' : 'phone number';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change $label?'),
        content: Text(
          'Please double-check your $label before confirming. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final currentValue =
        field == 'email' ? ref.read(editProfileProvider).profile.email : ref.read(editProfileProvider).profile.phone;
    context.push(
      RouteNames.updateContact,
      extra: {'field': field, 'currentValue': currentValue},
    );
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
                          avatarUrl: state.profile.avatarUrl,
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
                      errorText: _fieldErrors['name'],
                      onChanged: (_) => setState(() => _fieldErrors.remove('name')),
                    ),
                    SizedBox(height: 20.h),
                    LabeledFormField(
                      label: 'Email',
                      controller: _emailController,
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      enabled: false,
                      errorText: _fieldErrors['email'],
                      trailing: IconButton(
                        icon: SvgIcons.edit(size: 34.sp, color: AppColors.textSecondary),
                        onPressed: () => _confirmChangeContact(context, field: 'email'),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    LabeledFormField(
                      label: 'Phone number',
                      controller: _phoneController,
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      enabled: false,
                      errorText: _fieldErrors['phone'],
                      trailing: IconButton(
                        icon: SvgIcons.edit(size: 34.sp, color: AppColors.textSecondary),
                        onPressed: () => _confirmChangeContact(context, field: 'phone'),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    LabeledPickerField(
                      label: 'Country',
                      displayValue: state.profile.country ?? 'Choose',
                      isPlaceholder: state.profile.country == null,
                      onTap: () => _pickCountry(context),
                      errorText: _fieldErrors['country'],
                    ),
                    SizedBox(height: 20.h),
                    LabeledPickerField(
                      label: 'Birthdate',
                      displayValue: state.profile.birthDate == null
                          ? 'Choose'
                          : DateFormat.yMMMd().format(state.profile.birthDate!),
                      isPlaceholder: state.profile.birthDate == null,
                      onTap: () => _pickBirthDate(context),
                      errorText: _fieldErrors['birthDate'],
                    ),
                    SizedBox(height: 20.h),
                    LabeledFormField(
                      label: 'Pronouns',
                      controller: _pronounsController,
                      hintText: 'e.g. she/her, he/him, they/them',
                      errorText: _fieldErrors['pronouns'],
                      onChanged: (_) => setState(() => _fieldErrors.remove('pronouns')),
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
