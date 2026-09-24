import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';
import 'package:pms_app/features/affiliates/presentation/utils/affiliate_constants.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_form_fields.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_summary_card.dart';

class FamilyMembersPage extends ConsumerStatefulWidget {
  const FamilyMembersPage({super.key});

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
    final notifier = ref.read(affiliatesProvider(kOnboardingDraftPropertyId).notifier);
    final error = await notifier.addAffiliate(
      name: _nameController.text,
      contact: _contactController.text,
    );
    if (error == null) {
      _nameController.clear();
      _contactController.clear();
      setState(() => _showErrors = false);
    }
  }

  Future<void> _onEditMember(Affiliate affiliate) async {
    await context.push(RouteNames.editFamilyMember, extra: affiliate);
  }

  Future<void> _onDeleteMember(Affiliate affiliate) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove affiliate?'),
        content: Text('This will remove ${affiliate.name} from your affiliates.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(affiliatesProvider(kOnboardingDraftPropertyId).notifier).deleteAffiliate(affiliate.id);
    }
  }

  Future<void> _onNext() async {
    context.push(RouteNames.vehicles);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliatesProvider(kOnboardingDraftPropertyId));
    final notifier = ref.read(affiliatesProvider(kOnboardingDraftPropertyId).notifier);

    if (state.isLoading) {
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
          SecondaryButton(label: 'Add an affiliate', isLoading: state.isSubmittingDraft, onPressed: _onAddAffiliate),
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
          for (int i = 0; i < state.affiliates.length; i++) ...[
            AffiliateSummaryCard(
              affiliate: state.affiliates[i],
              index: i,
              total: state.affiliates.length,
              onAction: (action) {
                switch (action) {
                  case AffiliateCardAction.edit:
                    _onEditMember(state.affiliates[i]);
                    break;
                  case AffiliateCardAction.delete:
                    _onDeleteMember(state.affiliates[i]);
                    break;
                }
              },
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
