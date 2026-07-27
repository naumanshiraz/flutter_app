import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/property_detail/data/models/property_detail_model.dart';
import 'package:pms_app/features/property_detail/data/models/service_listing_model.dart';

/// **There is no backend yet.** Both methods simulate a network
/// round-trip against fixed mock data; the real REST calls are written
/// and commented directly below each, so flipping to a live API later
/// is a one-line change.
abstract class PropertyDetailRemoteDataSource {
  Future<PropertyDetailModel> getPropertyDetail(String propertyId);
  Future<List<ServiceListingModel>> getServices(String propertyId);
}

class PropertyDetailRemoteDataSourceImpl implements PropertyDetailRemoteDataSource {
  final Dio _dio;

  PropertyDetailRemoteDataSourceImpl(this._dio);

  /// **This is the one field to flip to see all 3 "Detailed view"
  /// variants from the design** — 'horizontal' | 'vertical' | 'grid'.
  /// It's a single screen-level value, not per-service, because a real
  /// backend would send one layout decision for the whole grid.
  static const String _mockServicesLayout = 'vertical';

  static const Map<String, dynamic> _mockPropertyDetail = {
    'id': 'gerlug-vista',
    'name': 'Gerlug Vista',
    'address': '15th Khoroo, Khan Uul District, Ulaanbaatar, Mongolia 13146',
    'heroImageUrls': [
      'https://picsum.photos/seed/gerlug-vista-1/800/400',
      'https://picsum.photos/seed/gerlug-vista-2/800/400',
      'https://picsum.photos/seed/gerlug-vista-3/800/400',
    ],
    'servicesLayout': _mockServicesLayout,
  };

  /// Order matters: `ServicesMasonryGrid` positions the first (or first
  /// three, in `vertical` mode) items specially based on
  /// `servicesLayout`, then falls back to a plain 2-column grid for the
  /// rest — matching all 3 "Detailed view" screenshots exactly.
  static const List<Map<String, dynamic>> _mockServices = [
    {
      'id': 'california_bakery',
      'name': 'California bakery',
      'description': 'Japanese style cake house',
      'imageUrl': 'https://picsum.photos/seed/california-bakery/400/600',
    },
    {
      'id': 'bb_butcher',
      'name': 'BB Butcher',
      'description': 'Daily fresh meat delivery',
      'imageUrl': 'https://picsum.photos/seed/bb-butcher/400/400',
    },
    {
      'id': 'printing_house',
      'name': 'Printing house',
      'description': 'High quality photo printing',
      'imageUrl': 'https://picsum.photos/seed/printing-house/400/400',
    },
    {
      'id': 'vinyl_shop',
      'name': 'Vinyl shop',
      'description': "60's, 70's, and 90's hit songs",
      'imageUrl': 'https://picsum.photos/seed/vinyl-shop/400/400',
    },
    {
      'id': 'bb_butcher',
      'name': 'BB Butcher',
      'description': 'Daily fresh meat delivery',
      'imageUrl': 'https://picsum.photos/seed/bb-butcher/400/400',
    },
    {
      'id': 'printing_house',
      'name': 'Printing house',
      'description': 'High quality photo printing',
      'imageUrl': 'https://picsum.photos/seed/printing-house/400/400',
    },
  ];

  @override
  Future<PropertyDetailModel> getPropertyDetail(String propertyId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return PropertyDetailModel.fromJson(_mockPropertyDetail);

      // final response = await _dio.get('/properties/$propertyId/detail');
      // return PropertyDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch property detail.');
    } catch (e) {
      throw ServerException('Unexpected error fetching property detail: $e');
    }
  }

  @override
  Future<List<ServiceListingModel>> getServices(String propertyId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return _mockServices.map(ServiceListingModel.fromJson).toList();

      // final response = await _dio.get('/properties/$propertyId/services');
      // final data = response.data as List<dynamic>;
      // return data.map((j) => ServiceListingModel.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch services.');
    } catch (e) {
      throw ServerException('Unexpected error fetching services: $e');
    }
  }
}
