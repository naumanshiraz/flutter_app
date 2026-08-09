import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_detail_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';

class InvoicePaymentPage extends ConsumerWidget {
  final String invoiceId;

  const InvoicePaymentPage({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceDetailNotifierProvider(invoiceId));
    final notifier = ref.read(invoiceDetailNotifierProvider(invoiceId).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              child: Row(
                children: [
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
                  Expanded(
                    child: Text(
                      state.detail?.label ?? 'Invoice',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
            ),
            Expanded(child: _buildBody(context, state, notifier)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, InvoiceDetailState state, InvoiceDetailNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null || state.detail == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 32.sp),
              SizedBox(height: 12.h),
              Text(state.error ?? 'Invoice not found.', textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
              SizedBox(height: 16.h),
              ElevatedButton(onPressed: notifier.refresh, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final detail = state.detail!;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        Text(detail.propertyName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 17.sp)),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(detail.propertyAddress, style: AppTextStyles.caption)),
            _kvColumn('Date:', detail.date, 'Due Date:', detail.dueDate, 'Invoice:', detail.invoiceNumber),
          ],
        ),
        SizedBox(height: 16.h),
        Text('Bill to:', style: AppTextStyles.caption),
        SizedBox(height: 4.h),
        Text(detail.billToName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(detail.billToAddress, style: AppTextStyles.caption)),
            Text.rich(
              TextSpan(
                text: 'Balance Due: ',
                style: AppTextStyles.caption,
                children: [
                  TextSpan(
                    text: detail.balanceDue,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        const Divider(color: AppColors.border),
        for (final charge in detail.charges) _chargeRow(charge.label, charge.amount),
        SizedBox(height: 20.h),
        OutlinedButton(
          onPressed: () => context.push(RouteNames.billingAccount),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          ),
          child: Text('Billing account', style: AppTextStyles.buttonSecondary),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24.r)),
          child: TextButton(
            onPressed: () => context.push(RouteNames.payment),
            style: TextButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12.h)),
            child: Text('Process payment', style: AppTextStyles.buttonPrimary),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _kvColumn(String l1, String v1, String l2, String v2, String l3, String v3) {
    Widget kv(String label, String value) => Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: Text.rich(
            TextSpan(
              text: '$label ',
              style: AppTextStyles.caption,
              children: [TextSpan(text: value, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700))],
            ),
          ),
        );
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [kv(l1, v1), kv(l2, v2), kv(l3, v3)]);
  }

  Widget _chargeRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body.copyWith(fontSize: 13.sp))),
          Text(value, style: AppTextStyles.body.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
