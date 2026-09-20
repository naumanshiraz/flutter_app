import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/home/data/models/profile_summary_model.dart';

abstract class HomeRemoteDataSource {
  Future<ProfileSummaryModel> getProfile();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<ProfileSummaryModel> getProfile() async {
    try {
      final response = await _dio.get(AppConstants.endpointProfile);
      return ProfileSummaryModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      throw ServerException(e.message ?? 'Failed to load profile.');
    } catch (e) {
      throw ServerException('Unexpected error loading profile: $e');
    }
  }
}
