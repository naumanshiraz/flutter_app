import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/features/splash/domain/entities/app_destination.dart';
import 'package:pms_app/features/splash/presentation/providers/splash_providers.dart';

class AppInitializationNotifier extends AsyncNotifier<AppDestination> {
  @override
  Future<AppDestination> build() async {
    final stopwatch = Stopwatch()..start();
    AppLogger.info('AppInitialization: starting bootstrap sequence.');

    try {
      final connectivity = ref.read(connectivityServiceProvider);
      final isOnline = await connectivity.isConnected;
      AppLogger.info('AppInitialization: connectivity = $isOnline');

      final checkAuthSessionUseCase = ref.read(checkAuthSessionUseCaseProvider);
      final result = await checkAuthSessionUseCase();

      final destination = result.when(
        onSuccess: (session) {
          AppLogger.info(
            'AppInitialization: session resolved (authenticated=${session.isAuthenticated})',
          );
          return session.isAuthenticated ? AppDestination.home : AppDestination.login;
        },
        onFailure: (failure) {
          AppLogger.warning(
            'AppInitialization: session check failed (${failure.message}). Falling back to Login.',
          );
          return AppDestination.login;
        },
      );

      await _enforceMinimumSplashDuration(stopwatch);
      return destination;
    } catch (e, st) {
      AppLogger.error('AppInitialization: unexpected bootstrap failure', e, st);
      await _enforceMinimumSplashDuration(stopwatch);
      // Fail safe: never strand the user on a broken splash screen.
      return AppDestination.login;
    }
  }

  Future<void> _enforceMinimumSplashDuration(Stopwatch stopwatch) async {
    final elapsed = stopwatch.elapsed;
    final remaining = AppConstants.splashMinimumDuration - elapsed;
    if (remaining > Duration.zero) {
      await Future.delayed(remaining);
    }
  }

  /// Allows the Login/OTP flow to force a re-evaluation after a
  /// successful sign-in (e.g. `ref.invalidate(appInitializationProvider)`).
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final appInitializationProvider =
    AsyncNotifierProvider<AppInitializationNotifier, AppDestination>(
  AppInitializationNotifier.new,
);
