import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';
import 'package:pms_app/features/family_members/presentation/providers/family_members_provider.dart';
import 'package:pms_app/features/family_members/presentation/widgets/family_member_form_fields.dart';

class EditFamilyMemberPage extends ConsumerStatefulWidget {
  final FamilyMember member;

  const EditFamilyMemberPage({super.key, required this.member});

  @override
  ConsumerState<EditFamilyMemberPage> createState() => _EditFamilyMemberPageState();
}

class _EditFamilyMemberPageState extends ConsumerState<EditFamilyMemberPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late String? _relationship;
  late int? _birthYear;
  late String? _gender;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _emailController = TextEditingController(text: widget.member.email);
    _phoneController = TextEditingController(text: widget.member.phone);
    _relationship = widget.member.relationship;
    _birthYear = widget.member.birthYear;
    _gender = widget.member.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final updated = widget.member.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      relationship: _relationship,
      birthYear: _birthYear,
      gender: _gender,
    );

    if (!updated.isValid) {
      setState(() => _errorMessage = 'Please complete every field.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final ok = await ref.read(familyMembersProvider.notifier).updateMember(updated);

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = ref.read(familyMembersProvider).errorMessage;
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
                      'Please note that you only need to include family '
                      'members living in this property or those requiring access.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(height: 24.h),
                    FamilyMemberFormFields(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      relationship: _relationship,
                      birthYear: _birthYear,
                      gender: _gender,
                      onRelationshipChanged: (v) => setState(() => _relationship = v),
                      onBirthYearChanged: (v) => setState(() => _birthYear = v),
                      onGenderChanged: (v) => setState(() => _gender = v),
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

/// Defensive fallback for the (unlikely) case someone deep-links to the
/// edit route without a member in `state.extra` — mirrors the pattern
/// used for OTP verification's missing-args case.
class EditFamilyMemberFallbackPage extends StatelessWidget {
  const EditFamilyMemberFallbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Edit Family Member',
      routeName: RouteNames.editFamilyMember,
    );
  }
}
