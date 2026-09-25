import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_form_fields.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_summary_card.dart';

class OccupantsPage extends ConsumerStatefulWidget {
  final String householdId;

  const OccupantsPage({super.key, required this.householdId});

  @override
  ConsumerState<OccupantsPage> createState() => _OccupantsPageState();
}

class _OccupantsPageState extends ConsumerState<OccupantsPage> {
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
    final notifier = ref.read(affiliatesProvider(widget.householdId).notifier);
    final error = await notifier.addAffiliate(name: _nameController.text, contact: _contactController.text);
    if (error == null) {
      _nameController.clear();
      _contactController.clear();
      setState(() => _showErrors = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliatesProvider(widget.householdId));
    final notifier = ref.read(affiliatesProvider(widget.householdId).notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text('Occupants', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < state.familyMembers.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: AffiliateSummaryCard(
                          affiliate: state.familyMembers[i],
                          index: i,
                          total: state.familyMembers.length,
                          onAction: (_) {},
                        ),
                      ),
                    for (int i = 0; i < state.tenants.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: AffiliateSummaryCard(
                          affiliate: state.tenants[i],
                          index: i,
                          total: state.tenants.length,
                          onAction: (_) {},
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
                      Text(state.errorMessage!, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                    ],
                    SizedBox(height: 24.h),
                    GradientButton(
                      label: 'Add an affiliate', 
                      isLoading: state.isSubmittingDraft, 
                      onPressed: _onAddAffiliate,
                      borderRadius: 10.r,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
