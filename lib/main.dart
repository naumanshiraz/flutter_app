import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/core/router/app_router.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/logger_service.dart';
import 'package:pms_app/core/theme/app_theme.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.error(
          'FlutterError: ${details.exceptionAsString()}',
          details.exception,
          details.stack,
        );
      };

      final localStorageService = LocalStorageService();
      await localStorageService.init();

      final container = ProviderContainer(
        overrides: [
          localStorageServiceProvider.overrideWithValue(localStorageService),
        ],
      );

      AppLogger.info('Bootstrap complete — launching ${AppConstants.appName}.');

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const PmsApp(),
        ),
      );
    },
    (error, stackTrace) {
      AppLogger.error('Uncaught zone error', error, stackTrace);
    },
  );
}

class PmsApp extends ConsumerWidget {
  const PmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoRouter router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
