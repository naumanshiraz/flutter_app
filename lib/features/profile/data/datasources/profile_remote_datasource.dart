import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/profile/data/models/editable_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<EditableProfileModel> getProfile();

  Future<void> updateProfile(EditableProfileModel profile);

  Future<void> updateContactIdentifier({required String field, required String value});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  EditableProfileModel _mapResponse(Map<String, dynamic> json) {
    final birthDateRaw = json['birth_date'] as String?;
    return EditableProfileModel(
      name: (json['full_name'] as String?)?.trim() ?? '',
      email: (json['email'] as String?)?.trim() ?? '',
      phone: (json['phone_number'] as String?)?.trim() ?? '',
      avatarUrl: json['avatar_url'] as String?,
      birthDate: birthDateRaw != null ? DateTime.tryParse(birthDateRaw) : null,
      country: json['location'] as String?,
    );
  }

  @override
  Future<EditableProfileModel> getProfile() async {
    try {
      final response = await _dio.get(AppConstants.endpointProfile);
      return _mapResponse(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      throw ServerException(e.message ?? 'Failed to load profile.');
    } catch (e) {
      throw ServerException('Unexpected error loading profile: $e');
    }
  }

  @override
  Future<void> updateProfile(EditableProfileModel profile) async {
    try {
      final birthDate = profile.birthDate;
      await _dio.patch(
        AppConstants.endpointProfile,
        data: {
          'full_name': profile.name,
          if (birthDate != null)
            'birth_date':
                '${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
          
          if (profile.country != null && profile.country!.isNotEmpty)
            'location': profile.country,
        },
      );

      // ---- Avatar upload: no documented endpoint yet -------------------
      // if (profile.avatarPath != null) {
      //   final formData = FormData.fromMap({
      //     'avatar': await MultipartFile.fromFile(profile.avatarPath!),
      //   });
      //   await _dio.post('${AppConstants.endpointProfile}/avatar', data: formData);
      // }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final serverError = (e.response?.data is Map) ? e.response?.data['error'] : null;
        throw ServerException(serverError?.toString() ?? 'Invalid profile data.');
      }
      throw ServerException(e.message ?? 'Failed to update profile.');
    } catch (e) {
      throw ServerException('Unexpected error updating profile: $e');
    }
  }

  @override
  Future<void> updateContactIdentifier({required String field, required String value}) async {
    try {
      // ---- MOCK (no documented endpoint yet; identifier already proven --
      // ---- via OTP by the time this is called) --------------------------
      await Future.delayed(const Duration(milliseconds: 600));

      // ---- REAL API (uncomment once the backend exists) ------------------
      // await _dio.patch(AppConstants.endpointProfile, data: {field: value});
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update $field.');
    } catch (e) {
      throw ServerException('Unexpected error updating $field: $e');
    }
  }
}
