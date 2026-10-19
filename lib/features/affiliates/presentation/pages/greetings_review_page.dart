import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/pages/property_assignment_page.dart';
import 'package:pms_app/features/join_requests/domain/entities/received_invitation.dart';
import 'package:pms_app/features/join_requests/presentation/providers/join_requests_provider.dart';

class GreetingsReviewPage extends ConsumerStatefulWidget {
  final ReceivedInvitation invitation;

  const GreetingsReviewPage({super.key, required this.invitation});

  @override
  ConsumerState<GreetingsReviewPage> createState() => _GreetingsReviewPageState();
}

class _GreetingsReviewPageState extends ConsumerState<GreetingsReviewPage> {
  bool _isProcessing = false;

  Affiliate get _affiliate {
    final i = widget.invitation;
    final relation = i.relation.isEmpty ? null : i.relation[0].toUpperCase() + i.relation.substring(1).toLowerCase();
    return Affiliate(
      id: i.id,
      name: i.inviterName,
      relationship: relation,
      status: i.status.isEmpty ? 'Pending' : i.status[0].toUpperCase() + i.status.substring(1).toLowerCase(),
    );
  }

  Future<void> _run(Future<String?> Function() action) async {
    setState(() => _isProcessing = true);
    final error = await action();
    if (!mounted) return;
    setState(() => _isProcessing = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pop();
  }

  void _onAccept() {
    _run(() => ref.read(receivedInvitationsProvider.notifier).accept(widget.invitation.id));
  }

  void _onDecline() {
    _run(() => ref.read(receivedInvitationsProvider.notifier).decline(widget.invitation.id));
  }

  void _onAssignPropertyNow(Affiliate affiliate) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PropertyAssignmentPage(affiliate: affiliate)));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(receivedInvitationsProvider);
    final name = widget.invitation.inviterName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text(
          "${name.isEmpty ? 'Invitation' : name}'s greetings",
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Please review the greetings', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
              SizedBox(height: 20.h),
              Expanded(child: SingleChildScrollView(child: _greetingCard(_affiliate))),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isProcessing ? null : _onDecline,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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
                onPressed: _onAccept,
                borderRadius: 10.r,
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
