import 'package:flutter/material.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// Temporary stand-in for routes that belong to modules not yet built
/// (Login, OTP, Onboarding, Home, ...). Each future module replaces the
/// corresponding entry in `app_router.dart` with its real page — this
/// widget itself is never imported by feature code, only by the router.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final String routeName;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyles.pageTitle),
              const SizedBox(height: 8),
              Text(
                'Route "$routeName" — module not yet implemented.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
