import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/confirm_dialog.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';
import 'package:pms_app/features/affiliates/presentation/utils/affiliate_constants.dart';
import 'package:pms_app/features/affiliates/presentation/utils/affiliate_validators.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_form_fields.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_summary_card.dart';
import 'package:pms_app/features/family_members/domain/entities/invitation.dart';
import 'package:pms_app/features/family_members/presentation/providers/invitations_provider.dart';

String _capitalize(String v) => v.isEmpty ? v : v[0].toUpperCase() + v.substring(1).toLowerCase();

Affiliate _invitationToAffiliate(Invitation i) => Affiliate(
      id: i.id,
      householdId: i.householdId,
      name: i.identifier,
      email: i.isEmail ? i.identifier : '',
      phone: i.isEmail ? '' : i.identifier,
      relationship: i.relation.isEmpty ? null : _capitalize(i.relation),
      status: _capitalize(i.status),
    );

class FamilyMembersPage extends ConsumerStatefulWidget {
  final String? householdId;

  const FamilyMembersPage({super.key, this.householdId});

  @override
  ConsumerState<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends ConsumerState<FamilyMembersPage> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  bool _showErrors = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _onAddAffiliate() async {
    setState(() => _showErrors = true);
    final relationship = ref.read(affiliatesProvider(kOnboardingDraftPropertyId)).draftRelationship;
    final error = AffiliateValidators.validateDraft(
      name: _nameController.text,
      contact: _contactController.text,
      relationship: relationship,
    );
    if (error != null) return;

    final submitError = await ref.read(invitationsProvider(widget.householdId ?? '').notifier).createInvitation(
          identifier: _contactController.text.trim(),
          relation: relationship == 'Tenant' ? 'tenant' : 'family',
        );
    if (!mounted) return;
    if (submitError != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(submitError)));
      return;
    }
    _nameController.clear();
    _contactController.clear();
    setState(() => _showErrors = false);
  }

  Future<void> _onDeleteMember(Affiliate affiliate) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Remove family member?',
      message: 'This will remove ${affiliate.name} from your family members. This action cannot be undone.',
    );
    if (confirmed) {
      await ref.read(affiliatesProvider(kOnboardingDraftPropertyId).notifier).deleteAffiliate(affiliate.id);
    }
  }

  Future<void> _onDeleteInvitation(Invitation invitation) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Remove family member?',
      message: 'This will remove ${invitation.identifier} from your family members. This action cannot be undone.',
    );
    if (!confirmed) return;
    final error = await ref.read(invitationsProvider(widget.householdId ?? '').notifier).deleteInvitation(invitation.id);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _onNext() async {
    context.push(RouteNames.vehicles);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliatesProvider(kOnboardingDraftPropertyId));
    final notifier = ref.read(affiliatesProvider(kOnboardingDraftPropertyId).notifier);
    final invitationsState = ref.watch(invitationsProvider(widget.householdId ?? ''));
    final invitationsNotifier = ref.read(invitationsProvider(widget.householdId ?? '').notifier);

    if (state.isLoading || invitationsState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2.4, valueColor: AlwaysStoppedAnimation(AppColors.primary)),
        ),
      );
    }

    return StepScaffold(
      currentStep: 2,
      totalSteps: 5,
      bottomButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SecondaryButton(label: 'Add an affiliate', isLoading: invitationsState.isSubmitting, onPressed: _onAddAffiliate),
          SizedBox(height: 12.h),
          GradientButton(label: 'Next', onPressed: _onNext),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Please identify your affiliates', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
          SizedBox(height: 12.h),
          Text(
            'Please note that you only need to include family members '
            'living in this property or those requiring access.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
          SizedBox(height: 20.h),
          if (invitationsState.error != null) ...[
            Text(
              invitationsState.error!,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
            TextButton(onPressed: invitationsNotifier.refresh, child: const Text('Retry')),
            SizedBox(height: 12.h),
          ],
          for (int i = 0; i < invitationsState.invitations.length; i++) ...[
            AffiliateSummaryCard(
              affiliate: _invitationToAffiliate(invitationsState.invitations[i]),
              index: i,
              total: invitationsState.invitations.length,
              showEdit: false,
              onAction: (_) => _onDeleteInvitation(invitationsState.invitations[i]),
            ),
            SizedBox(height: 20.h),
          ],
          for (int i = 0; i < state.affiliates.length; i++) ...[
            AffiliateSummaryCard(
              affiliate: state.affiliates[i],
              index: i,
              total: state.affiliates.length,
              showEdit: false,
              onAction: (_) => _onDeleteMember(state.affiliates[i]),
            ),
            SizedBox(height: 20.h),
          ],
          AffiliateFormFields(
            nameController: _nameController,
            contactController: _contactController,
            relationship: state.draftRelationship,
            onRelationshipChanged: notifier.updateDraftRelationship,
            showErrors: _showErrors,
          ),
          if (state.errorMessage != null) ...[
            SizedBox(height: 16.h),
            Text(state.errorMessage!, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
          ],
        ],
      ),
    );
  }
}
