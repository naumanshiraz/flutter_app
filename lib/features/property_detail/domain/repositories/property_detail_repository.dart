import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/property_detail/domain/entities/property_detail.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

/// Domain contract for the Property Detail screen. Presentation depends
/// only on this interface, never on the concrete data-layer types.
abstract class PropertyDetailRepository {
  Future<Result<PropertyDetail>> getPropertyDetail(String propertyId);

  /// The grid arrangement (which tile is full-width/tall/plain) is
  /// decided by the single `servicesLayout` value on [PropertyDetail]
  /// returned from [getPropertyDetail] — see [ServicesGridLayout].
  Future<Result<List<ServiceListing>>> getServices(String propertyId);
}
