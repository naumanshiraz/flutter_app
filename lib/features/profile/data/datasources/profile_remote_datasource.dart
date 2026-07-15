import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/profile/data/models/editable_profile_model.dart';

/// **There is no backend yet.** `updateProfile` simulates a network
/// round-trip with a delay; the real `PATCH /user/profile` call (and,
/// once file uploads are supported server-side, a multipart avatar
/// upload) is written and commented directly below — flip it the day a
/// backend exists. Nothing above this class needs to change.
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
