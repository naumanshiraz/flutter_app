import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/service_profile/data/models/service_profile_model.dart';

abstract class ServiceProfileRemoteDataSource {
  Future<ServiceProfileModel> getServiceProfile(String serviceId);
}

class ServiceProfileRemoteDataSourceImpl implements ServiceProfileRemoteDataSource {
  final Dio _dio;
  ServiceProfileRemoteDataSourceImpl(this._dio);

  static const Map<String, Map<String, dynamic>> _mockProfiles = {
    'california_bakery': {
      'id': 'california_bakery',
      'name': 'California bakery',
      'subtitle': 'Japanese style cake house',
      'heroImageUrl': 'https://picsum.photos/seed/california-bakery-hero/800/500',
      'tagline': 'Japanese cake | Fresh salads',
      'description':
          'California Bakery has several branches around UB, all designed for your comfort and a cozy atmosphere. '
              'Enjoy a cup of coffee while getting some work done with reliable WiFi. '
              'The mini-sandwiches and salads are fresh and tasty, and there is a wide selection of desserts and pastries to satisfy your sweet tooth.',
      'rating': 4.0,
      'comments': [
        {
          'id': 'c1',
          'authorInitial': 'ZT', 
          'authorName': 
          'Zolbayar Tuvshuu', 
          'text': 'I really like their mini sandwiches',
          'replies': [{
            'authorInitial': 'CB',
            'authorName': 'California Bakery',
            'text': 'Thank you! We are glad you enjoyed them.',
          },
          {
            'authorInitial': 'ZT',
            'authorName': 'Zolbayar Tuvshuu',
            'text': 'Will definitely visit again.',
          }
        ]},
      ],
    },
  };

  @override
  Future<ServiceProfileModel> getServiceProfile(String serviceId) async {
    try {
      // MOCK: no backend yet.
      await Future.delayed(const Duration(milliseconds: 400));
      final json = _mockProfiles[serviceId];
      if (json == null) throw ServerException('No profile for service "$serviceId".');
      return ServiceProfileModel.fromJson(json);

      // REAL API (uncomment once available)
      // final response = await _dio.get('/services/$serviceId/profile');
      // return ServiceProfileModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch service profile.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error fetching service profile: $e');
    }
  }
}
