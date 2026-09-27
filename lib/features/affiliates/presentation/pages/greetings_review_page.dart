import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/pages/property_assignment_page.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';

class GreetingsReviewPage extends ConsumerStatefulWidget {
  final String ownerName;

  const GreetingsReviewPage({super.key, required this.ownerName});

  @override
  ConsumerState<GreetingsReviewPage> createState() => _GreetingsReviewPageState();
}

class _GreetingsReviewPageState extends ConsumerState<GreetingsReviewPage> {
  bool _isProcessing = false;

  Future<void> _onAccept(List<Affiliate> pending) async {
    setState(() => _isProcessing = true);
    await ref.read(affiliatesProvider(null).notifier).acceptAffiliates(pending.map((a) => a.id).toList());
    if (mounted) setState(() => _isProcessing = false);
  }

  Future<void> _onDecline(List<Affiliate> pending) async {
    setState(() => _isProcessing = true);
    await ref.read(affiliatesProvider(null).notifier).declineAffiliates(pending.map((a) => a.id).toList());
    if (mounted) setState(() => _isProcessing = false);
  }

  void _onAssignPropertyNow(Affiliate affiliate) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PropertyAssignmentPage(affiliate: affiliate)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(affiliatesProvider(null));
    final pending = state.pendingFor(widget.ownerName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text(
          "${widget.ownerName}'s greetings",
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Please review the greetings', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
                    SizedBox(height: 20.h),
                    Expanded(
                      child: pending.isEmpty
                          ? Center(
                              child: Text('Nothing left to review.', style: AppTextStyles.bodySecondary),
                            )
                          : ListView.separated(
                              itemCount: pending.length,
                              separatorBuilder: (_, __) => SizedBox(height: 20.h),
                              itemBuilder: (context, i) => _greetingCard(pending[i]),
                            ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isProcessing || pending.isEmpty ? null : () => _onDecline(pending),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
                            ),
                            child: Text('Decline', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    GradientButton(
                      label: 'Accept',
                      isLoading: _isProcessing,
                      onPressed: pending.isEmpty ? () {} : () => _onAccept(pending),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _greetingCard(Affiliate affiliate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _field('Name', affiliate.name.isEmpty ? '-' : affiliate.name)),
                  Expanded(child: _field('Relationship', affiliate.relationship ?? '-')),
                  Expanded(child: _field('Invitation Status', affiliate.status)),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(child: _field('Email', affiliate.email.isEmpty ? '-' : affiliate.email)),
                  Expanded(child: _field('Phone', affiliate.phone.isEmpty ? '-' : affiliate.phone)),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Text(affiliate.isTenant ? 'Tenant' : 'Family member', style: AppTextStyles.caption),
            const Spacer(),
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_horiz, size: 20.sp, color: AppColors.textSecondary),
              onSelected: (_) => _onAssignPropertyNow(affiliate),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'assign', child: Text('Property assignment')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _field(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        SizedBox(height: 2.h),
        Text(value, style: AppTextStyles.body.copyWith(fontSize: 13.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
