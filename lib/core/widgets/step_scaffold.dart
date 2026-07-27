import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';

class StepProgressDots extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 0-based

  const StepProgressDots({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final bool isActive = index == currentStep;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: isActive ? 10.w : 7.w,
          height: isActive ? 10.w : 7.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isActive ? Border.all(color: AppColors.textPrimary, width: 1.4) : null,
            color: isActive ? Colors.white : AppColors.border,
          ),
        );
      }),
    );
  }
}

class StepScaffold extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Widget child;
  final Widget bottomButton;
  final VoidCallback? onBack;

  const StepScaffold({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.child,
    required this.bottomButton,
    this.onBack,
  });

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
              SizedBox(height: 8.h),
              SizedBox(
                height: 44.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                        onPressed: onBack ?? () => Navigator.maybePop(context),
                      ),
                    ),
                    StepProgressDots(totalSteps: totalSteps, currentStep: currentStep),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(child: SingleChildScrollView(child: child)),
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: bottomButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
