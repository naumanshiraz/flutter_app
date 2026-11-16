import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/grey_button.dart';
import 'package:pms_app/features/invoice/domain/entities/invoice.dart';
import 'package:pms_app/features/invoice/presentation/pages/invoice_payment_page.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_list_provider.dart';
import 'package:pms_app/features/invoice/presentation/providers/invoice_pdf_launcher.dart';

class InvoiceSheet extends ConsumerWidget {
  final String householdId;

  const InvoiceSheet({super.key, required this.householdId});

  static Future<void> show(BuildContext context, String householdId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      elevation: 0, // Remove shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => InvoiceSheet(householdId: householdId),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceListNotifierProvider(householdId));

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.25,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice', style: AppTextStyles.caption),
                SizedBox(height: 12.h),
                Expanded(child: _buildContent(context, ref, state, scrollController)),
                SizedBox(height: 12.h),
                Center(
                  child: SizedBox(
                    width: 120.w,
                    child: GreyButton(
                      label: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      height: 44.h,
                      borderRadius: 10.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    InvoiceListState state,
    ScrollController scrollController,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 28.sp),
            SizedBox(height: 8.h),
            Text(state.error!, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: ref.read(invoiceListNotifierProvider(householdId).notifier).refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.invoices.isEmpty) {
      return Center(child: Text('No invoices yet.', style: AppTextStyles.bodySecondary));
    }

    return ListView.separated(
      controller: scrollController,
      itemCount: state.invoices.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final invoice = state.invoices[index];
        return InkWell(
          onTap: () => _openPayment(context, invoice.id),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: _buildRow(context, ref, invoice),
          ),
        );
      },
    );
  }

  void _openPayment(BuildContext context, String invoiceId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => InvoicePaymentPage(invoiceId: invoiceId)));
  }

  Widget _buildRow(BuildContext context, WidgetRef ref, InvoiceSummary invoice) {
    return Row(
      children: [
        Expanded(
          child: Text(invoice.label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
        ),
        switch (invoice.status) {
          InvoiceStatus.pending => _badge('Pending', const Color(0xFF3B82F6)),
          InvoiceStatus.overdue => _badge('Overdue', AppColors.error),
          InvoiceStatus.none => const SizedBox.shrink(),
        },
        InkWell(
          onTap: () => openInvoicePdf(context, ref, invoice.id),
          child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Icon(Icons.file_download_outlined, size: 20.sp, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12.r)),
      child: Text(label, style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w600)),
    );
  }
}
