import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:pms_app/features/auth/presentation/providers/otp_verification_provider.dart';
import 'package:pms_app/features/profile/presentation/providers/profile_di_providers.dart';

const _reasons = [
  'Transferred ownership',
  'Moving out',
  'No longer using the app',
  'Other',
];

class AccountTerminationPage extends ConsumerStatefulWidget {
  const AccountTerminationPage({super.key});

  @override
  ConsumerState<AccountTerminationPage> createState() => _AccountTerminationPageState();
}

class _AccountTerminationPageState extends ConsumerState<AccountTerminationPage> {
  final _feedbackController = TextEditingController();
  String _reason = _reasons.first;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final profileResult = await ref.read(getEditableProfileUseCaseProvider)();
    final identifier = profileResult.when(
      onSuccess: (profile) => profile.email.isNotEmpty ? profile.email : profile.phone,
      onFailure: (_) => '',
    );

    if (identifier.isEmpty) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Could not load your account details. Please try again.';
      });
      return;
    }

    final identifierType = identifier.contains('@') ? IdentifierType.email : IdentifierType.phone;
    final useCase = ref.read(requestOtpUseCaseProvider);
    final result = await useCase(
      identifier: identifier,
      identifierType: identifierType,
      purpose: OtpPurpose.accountTermination,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      onSuccess: (_) {
        context.push(
          RouteNames.otpVerification,
          extra: OtpVerificationArgs(
            identifier: identifier,
            identifierType: identifierType,
            purpose: OtpPurpose.accountTermination,
            metadata: {
              'reason': _reason,
              'feedback': _feedbackController.text.trim(),
            },
          ),
        );
      },
      onFailure: (failure) => setState(() => _errorMessage = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 26.sp),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Account termination',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                "Please let us know why you're terminating your account. "
                'Your feedback is essential for us to enhance our service.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 24.h),
              Text('Reason', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(10.r)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _reason,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20.sp),
                    items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (value) => setState(() => _reason = value ?? _reason),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Tell us about your experience as a resident at this property.',
                  hintStyle: AppTextStyles.bodySecondary.copyWith(fontSize: 13.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.r), borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r), borderSide: BorderSide(color: AppColors.border)),
                ),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 12.h),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              SizedBox(height: 32.h),
              GradientButton(
                label: 'Confirm',
                isLoading: _isSubmitting,
                onPressed: _onConfirm,
                height: 44.h,
                borderRadius: 10.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
