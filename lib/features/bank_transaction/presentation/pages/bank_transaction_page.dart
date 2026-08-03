import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/bank_transaction/presentation/providers/bank_transaction_provider.dart';

class BankTransactionPage extends ConsumerWidget {
  final String paymentMethodId;

  const BankTransactionPage({super.key, required this.paymentMethodId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bankTransactionNotifierProvider(paymentMethodId));
    final notifier = ref.read(bankTransactionNotifierProvider(paymentMethodId).notifier);

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
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios_new)),
                  Expanded(
                    child: Text(
                      'Bank transaction',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
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

  Widget _buildBody(BuildContext context, BankTransactionState state, BankTransactionNotifier notifier) {
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
              Text(state.error ?? 'Not found.', textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
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
        Text(
          'Be careful with the transaction code provided below. The system uses it to update your payment status automatically.',
          style: AppTextStyles.caption,
        ),
        SizedBox(height: 20.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24.r)),
          alignment: Alignment.center,
          child: Text(detail.bankName, style: AppTextStyles.buttonPrimary),
        ),
        SizedBox(height: 20.h),
        _copyRow(context, detail.totalAmount, 'Total amount'),
        _copyRow(context, detail.accountNumber, 'Account number'),
        _copyRow(context, detail.beneficiary, 'Beneficiary'),
        _copyRow(context, detail.transactionCode, 'Transaction code'),
      ],
    );
  }

  Widget _copyRow(BuildContext context, String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
                Text(label, style: AppTextStyles.caption),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied.')));
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Copy', style: AppTextStyles.buttonSecondary.copyWith(fontSize: 13.sp)),
          ),
        ],
      ),
    );
  }
}
