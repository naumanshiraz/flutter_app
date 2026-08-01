import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/billing_account/domain/entities/billing_account.dart';
import 'package:pms_app/features/billing_account/presentation/providers/billing_account_form_provider.dart';

typedef _BillingAccountType = BillingAccountType;

class BillingAccountPage extends ConsumerStatefulWidget {
  const BillingAccountPage({super.key});

  @override
  ConsumerState<BillingAccountPage> createState() => _BillingAccountPageState();
}

class _BillingAccountPageState extends ConsumerState<BillingAccountPage> {
  _BillingAccountType _type = BillingAccountType.organization;
  final _taxIdController = TextEditingController(text: '6475356');
  final _orgNameController = TextEditingController(text: 'Uran shaglaa');
  final _registrationController = TextEditingController(text: 'UR88061218');

  @override
  void dispose() {
    _taxIdController.dispose();
    _orgNameController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(billingAccountFormNotifierProvider, (previous, next) {
      if (next.status == BillingAccountSubmitStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Billing account saved.')));
        Navigator.of(context).pop();
      } else if (next.status == BillingAccountSubmitStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error ?? 'Failed to save.')));
      }
    });
    final formState = ref.watch(billingAccountFormNotifierProvider);
    final isSubmitting = formState.status == BillingAccountSubmitStatus.submitting;

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
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  Text('Billing account', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  Text(
                    'Keep your private data secure. Also, be cautious with the following information, as it will be used to set up your billing account.',
                    style: AppTextStyles.caption,
                  ),
                  SizedBox(height: 20.h),
                  Text('Billing account type', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp)),
                  SizedBox(height: 8.h),
                  _dropdown(),
                  SizedBox(height: 20.h),
                  if (_type == _BillingAccountType.organization) ...[
                    _label('Tax identification number'),
                    SizedBox(height: 8.h),
                    _textField(_taxIdController),
                    SizedBox(height: 20.h),
                    _label('Organization name'),
                    SizedBox(height: 8.h),
                    _textField(_orgNameController, enabled: false),
                  ] else ...[
                    _label('Registration number'),
                    SizedBox(height: 8.h),
                    _textField(_registrationController),
                  ],
                  SizedBox(height: 24.h),
                  Container(
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24.r)),
                    child: TextButton(
                      onPressed: isSubmitting ? null : _onConfirm,
                      style: TextButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12.h)),
                      child: isSubmitting
                          ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text('Confirm', style: AppTextStyles.buttonPrimary),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm() {
    final account = BillingAccount(
      type: _type,
      taxIdentificationNumber: _type == BillingAccountType.organization ? _taxIdController.text : null,
      organizationName: _type == BillingAccountType.organization ? _orgNameController.text : null,
      registrationNumber: _type == BillingAccountType.individual ? _registrationController.text : null,
    );
    ref.read(billingAccountFormNotifierProvider.notifier).submit(account);
  }

  Widget _label(String text) => Text(text, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp));

  Widget _dropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10.r)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_BillingAccountType>(
          value: _type,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20.sp),
          items: const [
            DropdownMenuItem(value: _BillingAccountType.organization, child: Text('Organization or company')),
            DropdownMenuItem(value: _BillingAccountType.individual, child: Text('Individual')),
          ],
          onChanged: (value) => setState(() => _type = value ?? _type),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: AppTextStyles.body.copyWith(fontSize: 14.sp),
      decoration: InputDecoration(
        filled: !enabled,
        fillColor: AppColors.border.withOpacity(0.4),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.primary)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: const BorderSide(color: AppColors.border)),
      ),
    );
  }
}
