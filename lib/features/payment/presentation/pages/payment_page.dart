import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/payment/domain/entities/payment_method.dart';
import 'package:pms_app/features/payment/presentation/providers/payment_provider.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  static const _sectionTitles = {
    PaymentMethodCategory.bankApplication: 'Bank applications',
    PaymentMethodCategory.onlineWallet: 'Online wallets',
    PaymentMethodCategory.cardPayment: 'Card payment',
    PaymentMethodCategory.other: 'Other payment',
  };

  static const _sectionColors = {
    PaymentMethodCategory.bankApplication: Color(0xFF2E7CF6),
    PaymentMethodCategory.onlineWallet: Color(0xFFF6A623),
    PaymentMethodCategory.cardPayment: Color(0xFF2E7CF6),
    PaymentMethodCategory.other: Color(0xFF2E7CF6),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentNotifierProvider);
    final notifier = ref.read(paymentNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_ios_new)),
                  ),
                  Text('Payment', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
                ],
              ),
            ),
            Expanded(child: _buildBody(state, notifier)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(PaymentState state, PaymentNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.methods.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 32.sp),
              SizedBox(height: 12.h),
              Text(state.error!, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
              SizedBox(height: 16.h),
              ElevatedButton(onPressed: notifier.refresh, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final sections = <PaymentMethodCategory, List<PaymentMethod>>{};
    for (final method in state.methods) {
      sections.putIfAbsent(method.category, () => []).add(method);
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primary,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        children: [
          for (final category in PaymentMethodCategory.values)
            if (sections[category]?.isNotEmpty ?? false) _buildSection(category, sections[category]!),
        ],
      ),
    );
  }

  Widget _buildSection(PaymentMethodCategory category, List<PaymentMethod> methods) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_sectionTitles[category]!, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
          SizedBox(height: 8.h),
          for (final method in methods) _buildRow(method),
        ],
      ),
    );
  }

  Widget _buildRow(PaymentMethod method) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              'assets/images/${method.iconAsset}',
              width: 40.w,
              height: 40.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  method.subtitle,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 20.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String asset) {
    switch (asset) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'credit_card':
        return Icons.credit_card;
      case 'account_balance':
      default:
        return Icons.account_balance;
    }
  }
}
