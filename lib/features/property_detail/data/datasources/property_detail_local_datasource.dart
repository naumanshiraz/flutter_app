import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/property_detail/data/models/property_detail_model.dart';
import 'package:pms_app/features/property_detail/data/models/service_listing_model.dart';

abstract class PropertyDetailLocalDataSource {
  Future<PropertyDetailModel> fetchPropertyDetail(String propertyId);
  Future<List<ServiceListingModel>> fetchServices(String propertyId);
}

class PropertyDetailLocalDataSourceImpl implements PropertyDetailLocalDataSource {
  PropertyDetailLocalDataSourceImpl();

  @override
  Future<PropertyDetailModel> fetchPropertyDetail(String propertyId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return PropertyDetailModel(
        id: propertyId,
        name: 'Gerlug Vista',
        address: '15th Khoroo, Khan Uul District, Ulaanbaatar, Mongolia 13146',
        heroImageUrls: const [
          'https://picsum.photos/800/400?image=10',
        ],
        servicesLayout: 'grid',
      );
    } catch (e) {
      throw CacheException('Failed to read cached property detail: $e');
    }
  }

  @override
  Future<List<ServiceListingModel>> fetchServices(String propertyId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      return const [
        ServiceListingModel(
          id: 'house_printing_sticker',
          name: 'House printing sticker',
          description: 'High quality photo sticker printing and 3D printing',
          imageUrl: 'https://picsum.photos/seed/printing-sticker/800/400',
        ),
        ServiceListingModel(
          id: 'printing_house',
          name: 'Printing house',
          description: 'High quality photo printing',
          imageUrl: 'https://picsum.photos/seed/printing-house/400/400',
        ),
        ServiceListingModel(
          id: 'vinyl_shop',
          name: 'Vinyl shop',
          description: "60's, 70's, and 90's hit songs",
          imageUrl: 'https://picsum.photos/seed/vinyl-shop/400/400',
        ),
      ];
    } catch (e) {
      throw CacheException('Failed to read cached services: $e');
    }
  }
}
