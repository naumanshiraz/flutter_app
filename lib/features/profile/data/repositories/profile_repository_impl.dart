import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/profile/data/datasources/profile_device_datasource.dart';
import 'package:pms_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:pms_app/features/profile/data/models/editable_profile_model.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';
import 'package:pms_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileDeviceDataSource _deviceDataSource;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileDeviceDataSource deviceDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _deviceDataSource = deviceDataSource;

  @override
  Future<Result<EditableProfile>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return Success(model.toEntity());
    } on UnauthorizedException catch (e) {
      return ResultError(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load profile: $e'));
    }
  }

  @override
  Future<Result<void>> updateProfile(EditableProfile profile) async {
    try {
      final model = EditableProfileModel.fromEntity(profile);
      await _remoteDataSource.updateProfile(model);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update profile: $e'));
    }
  }

  @override
  Future<Result<String>> pickProfilePicture(ProfilePictureSource source) async {
    try {
      final path = await _deviceDataSource.pickImage(source);
      return Success(path);
    } on ImagePickCancelledException {
      return const ResultError(PickCancelledFailure());
    } on PermissionException catch (e) {
      return ResultError(PermissionFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to pick an image: $e'));
    }
  }

  @override
  Future<Result<void>> updateContactIdentifier({required String field, required String value}) async {
    try {
      await _remoteDataSource.updateContactIdentifier(field: field, value: value);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update $field: $e'));
    }
  }

  @override
  Future<Result<String>> uploadAvatar(String filePath) async {
    try {
      final avatarUrl = await _remoteDataSource.uploadAvatar(filePath);
      return Success(avatarUrl);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to upload photo: $e'));
    }
  }

  @override
  Future<Result<void>> deleteAvatar() async {
    try {
      await _remoteDataSource.deleteAvatar();
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to remove photo: $e'));
    }
  }
}
