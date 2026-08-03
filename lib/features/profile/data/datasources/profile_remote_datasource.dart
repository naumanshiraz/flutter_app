import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/profile/data/models/editable_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile(EditableProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<void> updateProfile(EditableProfileModel profile) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 600));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // await _dio.patch(AppConstants.endpointProfile, data: profile.toJson());
      // if (profile.avatarPath != null) {
      //   final formData = FormData.fromMap({
      //     'avatar': await MultipartFile.fromFile(profile.avatarPath!),
      //   });
      //   await _dio.post('${AppConstants.endpointProfile}/avatar', data: formData);
      // }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update profile.');
    } catch (e) {
      throw ServerException('Unexpected error updating profile: $e');
    }
  }
}
