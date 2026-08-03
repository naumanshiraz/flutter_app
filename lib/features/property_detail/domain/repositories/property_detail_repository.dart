import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/property_detail/domain/entities/property_detail.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

abstract class PropertyDetailRepository {
  Future<Result<PropertyDetail>> getPropertyDetail(String propertyId);

  Future<Result<List<ServiceListing>>> getServices(String propertyId);
}
