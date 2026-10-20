import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/join_requests/domain/entities/join_request.dart';
import 'package:pms_app/features/join_requests/presentation/providers/join_requests_provider.dart';
import 'package:pms_app/features/join_requests/presentation/widgets/join_request_card.dart';
import 'package:pms_app/features/join_requests/presentation/widgets/reason_dialog.dart';

class JoinRequestReviewPage extends ConsumerStatefulWidget {
  final JoinRequest request;

  const JoinRequestReviewPage({super.key, required this.request});

  @override
  ConsumerState<JoinRequestReviewPage> createState() => _JoinRequestReviewPageState();
}

class _JoinRequestReviewPageState extends ConsumerState<JoinRequestReviewPage> {
  bool _processing = false;

  Future<void> _run(Future<String?> Function() action) async {
    setState(() => _processing = true);
    final error = await action();
    if (!mounted) return;
    setState(() => _processing = false);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _approve() => _run(() => ref.read(joinRequestsProvider.notifier).approve(widget.request.id));

  Future<void> _reject() async {
    final reason = await ReasonDialog.show(context);
    if (reason == null || !mounted) return;
    await _run(() => ref.read(joinRequestsProvider.notifier).reject(widget.request.id, reason));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(joinRequestsProvider);
    final name = widget.request.requesterName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text(
          "${name.isEmpty ? 'Join request' : name}'s request",
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Please review the request', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
              SizedBox(height: 20.h),
              Expanded(child: SingleChildScrollView(child: JoinRequestCard(request: widget.request))),
              SizedBox(height: 16.h),
              OutlinedButton(
                onPressed: _processing ? null : _reject,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text('Reject', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              SizedBox(height: 12.h),
              GradientButton(label: 'Approve', isLoading: _processing, onPressed: _approve, borderRadius: 10.r),
            ],
          ),
        ),
      ),
    );
  }
}
