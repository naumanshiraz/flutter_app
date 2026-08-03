import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/splash/domain/entities/app_destination.dart';
import 'package:pms_app/features/splash/presentation/providers/app_initialization_provider.dart';
import 'package:pms_app/features/splash/presentation/widgets/splash_logo.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listening (not watching) is enough: GoRouter's `refreshListenable`
    // + `redirect` callback perform the actual navigation once this
    // provider resolves. We only need to know about hard failures here.
    ref.listen<AsyncValue<AppDestination>>(appInitializationProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          // The notifier already falls back to Login internally, so a
          // surfaced error here would be truly unexpected. Log-only.
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SplashLogo(size: 96),
              const SizedBox(height: 20),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: AppTextStyles.appTitle,
              ),
              const SizedBox(height: 40),
              const _SplashLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashLoadingIndicator extends ConsumerWidget {
  const _SplashLoadingIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = ref.watch(appInitializationProvider);

    return initState.maybeWhen(
      orElse: () => const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
      data: (_) => const SizedBox(height: 28),
    );
  }
}
