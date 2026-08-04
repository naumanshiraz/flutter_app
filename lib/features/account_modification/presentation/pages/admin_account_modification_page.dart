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
import 'package:pms_app/features/profile/presentation/widgets/labeled_form_field.dart';

class AdminAccountModificationPage extends ConsumerStatefulWidget {
  const AdminAccountModificationPage({super.key});

  @override
  ConsumerState<AdminAccountModificationPage> createState() => _AdminAccountModificationPageState();
}

class _AdminAccountModificationPageState extends ConsumerState<AdminAccountModificationPage> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final newValue = _newController.text.trim();
    if (newValue.isEmpty) {
      setState(() => _errorMessage = 'Please enter a new phone number or email address.');
      return;
    }
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final identifierType = newValue.contains('@') ? IdentifierType.email : IdentifierType.phone;
    final useCase = ref.read(requestOtpUseCaseProvider);
    final result = await useCase(
      identifier: newValue,
      identifierType: identifierType,
      purpose: OtpPurpose.adminAccountModification,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      onSuccess: (_) {
        context.push(
          RouteNames.otpVerification,
          extra: OtpVerificationArgs(
            identifier: newValue,
            identifierType: identifierType,
            purpose: OtpPurpose.adminAccountModification,
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
                      'Admin account modification',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Keep your private data secure. As you intend to pass on your '
                'admin rights, please ensure the accuracy of the following '
                'information.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.sp),
              ),
              SizedBox(height: 24.h),
              LabeledFormField(
                label: 'Your phone number or email address',
                controller: _currentController,
                hintText: 'dtulgabtr@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.h),
              LabeledFormField(
                label: 'New phone number or email address',
                controller: _newController,
                hintText: 'internine@gmail.com',
                keyboardType: TextInputType.emailAddress,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
