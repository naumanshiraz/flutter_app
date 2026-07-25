import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/step_scaffold.dart';

class ResidencyTermsPage extends ConsumerStatefulWidget {
  const ResidencyTermsPage({super.key});

  @override
  ConsumerState<ResidencyTermsPage> createState() => _ResidencyTermsPageState();
}

class _ResidencyTermsPageState extends ConsumerState<ResidencyTermsPage> {
  bool _agreedToTerms = false;

  Future<void> _onDecline() async {
    context.pop();
  }

  Future<void> _onAccept() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to terms to continue')),
      );
      return;
    }
    context.push(RouteNames.familyMembers);
  }

  @override
  Widget build(BuildContext context) {
    return StepScaffold(
      currentStep: 1,
      totalSteps: 5,
      bottomButton: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _onDecline,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                'Decline',
                style: AppTextStyles.buttonSecondary.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _onAccept,
                  borderRadius: BorderRadius.circular(24.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Center(
                      child: Text(
                        'Accept',
                        style: AppTextStyles.buttonPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Terms of Residency Service',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle,
            ),
            SizedBox(height: 24.h),
            _buildSectionContent(
              'The Owner and the Manager are referred to individually as a "Party" and collectively as the "Parties"',
            ),
            SizedBox(height: 16.h),
            _buildSectionContent(
              'This Property Management Agreement (the "Agreement") is entered into and made valid upon signature by both Parties. This date is hereinafter referred to as the "Effective Date".',
            ),
            SizedBox(height: 16.h),
            _buildSectionTitle('1. Purpose'),
            SizedBox(height: 12.h),
            _buildSectionContent(
              'The Owner owns the property located at. The Manager is in the business of managing properties of this type. The Owner desires to engage the Manager to manage the Property.',
            ),
            SizedBox(height: 16.h),
            _buildSectionTitle('2. Manager\'s Responsibilities'),
            SizedBox(height: 12.h),
            _buildSectionContent(
              'The Manager agrees to perform the following duties and responsibilities with regards to the Property:',
            ),
            SizedBox(height: 16.h),
            _buildSectionTitle('3. Advertising of Property'),
            SizedBox(height: 12.h),
            _buildSectionContent(
              'The Manager shall advertise the Property for rent, engage and screen potential renters and enter into rental agreement(s) with acceptable renter(s). The Owner shall reimburse the Manager for all expenses related to such advertising. The Manager shall notify the Owner, in advance, of anticipated expenses related with such advertising.',
            ),
            SizedBox(height: 16.h),
            _buildSectionTitle('4. Collection & Disbursement of Rent'),
            SizedBox(height: 12.h),
            _buildSectionContent(
              'The Manager shall be responsible for all collection of rent earned on the Property. The Manager shall then be responsible for disbursement of those proceeds to the Owner. The Owner shall provide the Manager with direction as to how proceeds shall be disbursed. The Manager shall further prepare and provide to the Owner a detailed accounting of all rents, expenses, and disbursements.',
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() => _agreedToTerms = value ?? false);
                    },
                    activeColor: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'I have read and agree to the Terms of Residency Service',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.body.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: AppTextStyles.bodySecondary.copyWith(
        height: 1.5,
      ),
    );
  }
}