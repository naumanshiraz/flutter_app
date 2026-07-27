import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/network/dio_client.dart';
import 'package:pms_app/core/services/connectivity_service.dart';
import 'package:pms_app/core/services/local_storage_service.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageServiceImpl();
});

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
