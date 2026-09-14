import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/splash/domain/entities/app_destination.dart';
import 'package:pms_app/features/splash/presentation/providers/app_initialization_provider.dart';
import 'package:pms_app/features/splash/presentation/widgets/splash_logo.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AppDestination>>(appInitializationProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          // Handle initialization error if needed
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
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
                const _SplashStatus(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashStatus extends ConsumerWidget {
  const _SplashStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initState = ref.watch(appInitializationProvider);

    return initState.maybeWhen(
      data: (destination) => destination == AppDestination.offline
          ? _OfflineMessage(
              onRetry: () => ref.read(appInitializationProvider.notifier).refresh(),
            )
          : const SizedBox(height: 28),
      orElse: () => const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.6,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}

class _OfflineMessage extends StatelessWidget {
  final VoidCallback onRetry;

  const _OfflineMessage({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off_rounded, size: 32, color: AppColors.textSecondary),
        const SizedBox(height: 12),
        Text(
          'No internet connection',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Please check your connection and try again.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySecondary,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: onRetry,
          child: Text('Retry', style: AppTextStyles.linkText),
        ),
      ],
    );
  }
}
