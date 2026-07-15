import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';
import 'package:pms_app/features/family_members/presentation/providers/family_members_provider.dart';
import 'package:pms_app/features/family_members/presentation/widgets/family_member_form_fields.dart';
import 'package:pms_app/features/family_members/presentation/widgets/family_member_summary_card.dart';

/// Matches the design's "Please identify your affiliates" screens:
/// step 2 of the multi-step flow (back arrow + dots), a summary card
/// per already-added affiliate (with an Edit/Delete overflow menu), a
/// draft form below it for adding the next one, "Add an affiliate",
/// and "Next".
///
/// Only this step's design was provided — steps 3-5 aren't specified
/// yet, so "Next" persists whatever's in the list and returns to Home;
/// chain the next route here once those designs arrive.
class FamilyMembersPage extends ConsumerStatefulWidget {
  const FamilyMembersPage({super.key});

  @override
  ConsumerState<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends ConsumerState<FamilyMembersPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _clearDraftControllers() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
  }

  Future<void> _onAddAffiliate() async {
    final notifier = ref.read(familyMembersProvider.notifier);
    notifier.updateDraft(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    final ok = await notifier.addDraftAsMember();
    if (ok) _clearDraftControllers();
  }

  Future<void> _onEditMember(FamilyMember member) async {
    await context.push(RouteNames.editFamilyMember, extra: member);
  }

  Future<void> _onDeleteMember(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove family member?'),
        content: Text('This will remove ${member.name} from your affiliates.'),
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
      await ref.read(familyMembersProvider.notifier).deleteMember(member.id);
    }
  }

  Future<void> _onNext() async {
    // Continue the multi-step flow into the next provided design
    // (Specify Property) rather than returning to Home.
    context.push(RouteNames.properties);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(familyMembersProvider);
    final notifier = ref.read(familyMembersProvider.notifier);

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
      currentStep: 1,
      totalSteps: 5,
      bottomButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton(
            label: 'Add an affiliate',
            isLoading: state.isSubmittingDraft,
            onPressed: _onAddAffiliate,
          ),
          SizedBox(height: 12.h),
          GradientButton(label: 'Next', onPressed: _onNext),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Please identify your affiliates',
            textAlign: TextAlign.center,
            style: AppTextStyles.pageTitle,
          ),
          SizedBox(height: 12.h),
          Text(
            'Please note that you only need to include family members '
            'living in this property or those requiring access.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 20.h),
          for (int i = 0; i < state.members.length; i++) ...[
            FamilyMemberSummaryCard(
              member: state.members[i],
              index: i,
              total: state.members.length,
              onAction: (action) {
                switch (action) {
                  case FamilyMemberCardAction.edit:
                    _onEditMember(state.members[i]);
                    break;
                  case FamilyMemberCardAction.delete:
                    _onDeleteMember(state.members[i]);
                    break;
                }
              },
            ),
            SizedBox(height: 20.h),
          ],
          FamilyMemberFormFields(
            nameController: _nameController,
            emailController: _emailController,
            phoneController: _phoneController,
            relationship: state.draft.relationship,
            birthYear: state.draft.birthYear,
            gender: state.draft.gender,
            onRelationshipChanged: (v) => notifier.updateDraft(relationship: v),
            onBirthYearChanged: (v) => notifier.updateDraft(birthYear: v),
            onGenderChanged: (v) => notifier.updateDraft(gender: v),
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
    );
  }
}
