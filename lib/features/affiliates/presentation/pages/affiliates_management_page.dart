import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_form_fields.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_summary_card.dart';

class AffiliatesManagementPage extends ConsumerStatefulWidget {
  const AffiliatesManagementPage({super.key});

  @override
  ConsumerState<AffiliatesManagementPage> createState() => _AffiliatesManagementPageState();
}

class _AffiliatesManagementPageState extends ConsumerState<AffiliatesManagementPage> {
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
    final notifier = ref.read(affiliatesProvider(null).notifier);
    final error = await notifier.addAffiliate(name: _nameController.text, contact: _contactController.text);
    if (error == null) {
      _nameController.clear();
      _contactController.clear();
      setState(() => _showErrors = false);
    }
  }

  Future<void> _onDelete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove affiliate?'),
        content: const Text('This will remove this affiliate.'),
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
      await ref.read(affiliatesProvider(null).notifier).deleteAffiliate(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliatesProvider(null));
    final notifier = ref.read(affiliatesProvider(null).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text(
          'Affiliates management',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please identify your affiliates',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle,
                    ),
                    SizedBox(height: 20.h),
                    for (int i = 0; i < state.affiliates.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: AffiliateSummaryCard(
                          affiliate: state.affiliates[i],
                          index: i,
                          total: state.affiliates.length,
                          onAction: (action) {
                            switch (action) {
                              case AffiliateCardAction.edit:
                                context.push(RouteNames.editFamilyMember, extra: state.affiliates[i]);
                                break;
                              case AffiliateCardAction.delete:
                                _onDelete(state.affiliates[i].id);
                                break;
                            }
                          },
                        ),
                      ),
                    SizedBox(height: 4.h),
                    AffiliateFormFields(
                      nameController: _nameController,
                      contactController: _contactController,
                      relationship: state.draftRelationship,
                      onRelationshipChanged: notifier.updateDraftRelationship,
                      showErrors: _showErrors,
                    ),
                    if (state.errorMessage != null) ...[
                      SizedBox(height: 12.h),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(color: AppColors.error),
                      ),
                    ],
                    SizedBox(height: 24.h),
                    GradientButton(
                      label: 'Add an affiliate',
                      isLoading: state.isSubmittingDraft,
                      onPressed: _onAddAffiliate,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
