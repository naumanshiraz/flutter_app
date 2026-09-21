import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/profile/data/datasources/profile_device_datasource.dart';
import 'package:pms_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:pms_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:pms_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:pms_app/features/profile/domain/usecases/profile_usecases.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final profileDeviceDataSourceProvider = Provider<ProfileDeviceDataSource>((ref) {
  return ProfileDeviceDataSourceImpl();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    deviceDataSource: ref.watch(profileDeviceDataSourceProvider),
  );
});

final getEditableProfileUseCaseProvider = Provider<GetEditableProfileUseCase>((ref) {
  return GetEditableProfileUseCase(ref.watch(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(profileRepositoryProvider));
});

final pickProfilePictureUseCaseProvider = Provider<PickProfilePictureUseCase>((ref) {
  return PickProfilePictureUseCase(ref.watch(profileRepositoryProvider));
});

final updateContactIdentifierUseCaseProvider = Provider<UpdateContactIdentifierUseCase>((ref) {
  return UpdateContactIdentifierUseCase(ref.watch(profileRepositoryProvider));
});

final uploadAvatarUseCaseProvider = Provider<UploadAvatarUseCase>((ref) {
  return UploadAvatarUseCase(ref.watch(profileRepositoryProvider));
});

final deleteAvatarUseCaseProvider = Provider<DeleteAvatarUseCase>((ref) {
  return DeleteAvatarUseCase(ref.watch(profileRepositoryProvider));
});
