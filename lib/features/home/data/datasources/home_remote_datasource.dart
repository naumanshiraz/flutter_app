import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/home/data/models/property_listing_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<PropertyListingModel>> getPropertyListings();
}

/// **There is no backend yet.** This returns a fixed mocked JSON payload
/// (with an artificial delay) instead of calling `GET /properties`. The
/// real call is written and commented directly below the mock — flip
/// them the day a backend exists; nothing above this class changes.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockPropertiesJson = [
    {
      'id': 'p1',
      'title': 'Burj Khalifa',
      'managementCompany': 'Mahmud Management Group',
      'imageUrl': 'https://picsum.photos/seed/burjkhalifa1/600/500',
    },
    {
      'id': 'p2',
      'title': 'Miami Beach',
      'managementCompany': 'Regis Property Management',
      'imageUrl': 'https://picsum.photos/seed/miamibeach1/600/500',
    },
    {
      'id': 'p3',
      'title': 'Burj Khalifa',
      'managementCompany': 'Mahmud Management Group',
      'imageUrl': 'https://picsum.photos/seed/burjkhalifa2/600/500',
    },
    {
      'id': 'p4',
      'title': 'Miami Beach',
      'managementCompany': 'Regis Property Management',
      'imageUrl': 'https://picsum.photos/seed/miamibeach2/600/500',
    },
    {
      'id': 'p5',
      'title': 'Downtown Loft',
      'managementCompany': 'Skyline Realty Partners',
      'imageUrl': 'https://picsum.photos/seed/downtownloft1/600/500',
    },
    {
      'id': 'p6',
      'title': 'Lakeside Residences',
      'managementCompany': 'Regis Property Management',
      'imageUrl': 'https://picsum.photos/seed/lakeside1/600/500',
    },
  ];

  @override
  Future<List<PropertyListingModel>> getPropertyListings() async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 700));
      return _mockPropertiesJson.map(PropertyListingModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(AppConstants.endpointProperties);
      // final data = response.data as List<dynamic>;
      // return data
      //     .map((json) => PropertyListingModel.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load property listings.');
    } catch (e) {
      throw ServerException('Unexpected error loading property listings: $e');
    }
  }
}
