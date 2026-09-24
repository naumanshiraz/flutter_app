import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_form_fields.dart';

class EditFamilyMemberPage extends ConsumerStatefulWidget {
  final Affiliate affiliate;

  const EditFamilyMemberPage({super.key, required this.affiliate});

  @override
  ConsumerState<EditFamilyMemberPage> createState() => _EditFamilyMemberPageState();
}

class _EditFamilyMemberPageState extends ConsumerState<EditFamilyMemberPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  late String? _relationship;

  bool _isSaving = false;
  bool _showErrors = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.affiliate.name);
    _contactController = TextEditingController(
      text: widget.affiliate.email.isNotEmpty ? widget.affiliate.email : widget.affiliate.phone,
    );
    _relationship = widget.affiliate.relationship;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    setState(() => _showErrors = true);
    final contact = _contactController.text.trim();
    final isEmail = contact.contains('@');
    final updated = widget.affiliate.copyWith(
      name: _nameController.text.trim(),
      email: isEmail ? contact : '',
      phone: isEmail ? '' : contact,
      relationship: _relationship,
    );

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final notifier = ref.read(affiliatesProvider(updated.householdId).notifier);
    final ok = await notifier.updateAffiliate(updated);

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = ref.read(affiliatesProvider(updated.householdId)).errorMessage;
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
                    child: Text('Edit', textAlign: TextAlign.center, style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp)),
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
                    AffiliateFormFields(
                      nameController: _nameController,
                      contactController: _contactController,
                      relationship: _relationship,
                      onRelationshipChanged: (v) => setState(() => _relationship = v),
                      showErrors: _showErrors,
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 16.h),
                      Text(_errorMessage!, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
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
