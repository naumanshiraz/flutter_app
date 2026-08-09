import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/invoice/presentation/pages/invoice_payment_page.dart';
import 'package:pms_app/core/widgets/grey_button.dart';

enum _InvoiceStatus { pending, overdue, none }

class _InvoiceRow {
  final String id;
  final String label;
  final _InvoiceStatus status;
  const _InvoiceRow(this.id, this.label, this.status);
}

class InvoiceSheet extends StatelessWidget {
  const InvoiceSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      elevation: 0, // Remove shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => const InvoiceSheet(),
    );
  }

  static const _invoices = [
    _InvoiceRow('inv-2024-05', 'May 5, 2024 - Invoice', _InvoiceStatus.pending),
    _InvoiceRow('inv-2024-04', 'April 5, 2024 - Invoice', _InvoiceStatus.overdue),
    _InvoiceRow('inv-2024-03', 'March 5, 2024 - Invoice', _InvoiceStatus.none),
  ];

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: _invoices.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => _openPayment(context, _invoices[index].id),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: _buildRow(_invoices[index]),
                      ),
                    ),
                  ),
                ),
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

  void _openPayment(BuildContext context, String invoiceId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => InvoicePaymentPage(invoiceId: invoiceId)));
  }

  Widget _buildRow(_InvoiceRow row) {
    return Row(
      children: [
        Expanded(
          child: Text(row.label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
        ),
        switch (row.status) {
          _InvoiceStatus.pending => _badge('Pending', const Color(0xFF3B82F6)),
          _InvoiceStatus.overdue => _badge('Overdue', AppColors.error),
          _InvoiceStatus.none => Icon(Icons.file_download_outlined, size: 20.sp, color: AppColors.textSecondary),
        },
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