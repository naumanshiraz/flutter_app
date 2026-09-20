import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/validators.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/features/auth/domain/entities/otp_session.dart';
import 'package:pms_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:pms_app/features/auth/presentation/providers/otp_verification_provider.dart';

class UpdateContactPage extends ConsumerStatefulWidget {
  final String field;
  final String currentValue;

  const UpdateContactPage({super.key, required this.field, required this.currentValue});

  @override
  ConsumerState<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends ConsumerState<UpdateContactPage> {
  late final TextEditingController _controller;
  bool _isSubmitting = false;
  String? _errorMessage;

  bool get _isEmail => widget.field == 'email';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onUpdate() async {
    final value = _controller.text.trim();
    final error = _isEmail ? Validators.emailError(value) : Validators.phoneError(value);
    if (error != null) {
      setState(() => _errorMessage = error);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final useCase = ref.read(requestOtpUseCaseProvider);
    final result = await useCase(
      identifier: value,
      identifierType: _isEmail ? IdentifierType.email : IdentifierType.phone,
      purpose: OtpPurpose.profileContactUpdate,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      onSuccess: (_) {
        context.push(
          RouteNames.otpVerification,
          extra: OtpVerificationArgs(
            identifier: value,
            identifierType: _isEmail ? IdentifierType.email : IdentifierType.phone,
            purpose: OtpPurpose.profileContactUpdate,
            metadata: {'field': widget.field},
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
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Edit profile',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp),
                    ),
                  ),
                  SizedBox(width: 48.w),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                _isEmail ? 'Enter your new email address' : 'Enter your new phone number',
                textAlign: TextAlign.center,
                style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                'We\'ll send a 6-digit code to confirm it\'s really you before this change takes effect.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
              SizedBox(height: 24.h),
              LabeledFormField(
                label: _isEmail ? 'Email' : 'Phone number',
                controller: _controller,
                hintText: _isEmail ? 'Enter your email address' : 'Enter your phone number',
                keyboardType: _isEmail ? TextInputType.emailAddress : TextInputType.phone,
                errorText: _errorMessage,
              ),
              SizedBox(height: 28.h),
              GradientButton(
                label: 'Update',
                isLoading: _isSubmitting,
                onPressed: _onUpdate,
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
