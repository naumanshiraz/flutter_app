import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/network/dio_client.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';

/// -------------------------------------------------------------------
/// Core-level DI graph (Riverpod). Every future module reads these
/// providers instead of instantiating services directly — this is the
/// single place that wires concrete implementations to their
/// abstractions, so tests can override any of them freely.
/// -------------------------------------------------------------------

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl();
});

/// [LocalStorageService] must be initialized (Hive boxes opened) before
/// this provider is read. `main.dart` awaits `.init()` during bootstrap
/// and overrides this provider with the already-initialized instance.
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'localStorageServiceProvider must be overridden in main.dart after '
    'LocalStorageService.init() completes.',
  );
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityServiceImpl();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return DioClient(secureStorage: secureStorage);
});
