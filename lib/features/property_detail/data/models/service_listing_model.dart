import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

part 'service_listing_model.freezed.dart';
part 'service_listing_model.g.dart';

/// Data-layer shape for one "Available services" tile — exactly the
/// shape a real `GET /properties/{id}/services` would return. No
/// per-item layout field: the grid arrangement is a single screen-level
/// value on `PropertyDetailModel.servicesLayout`, not per service.
@freezed
class ServiceListingModel with _$ServiceListingModel {
  const ServiceListingModel._();

  const factory ServiceListingModel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
  }) = _ServiceListingModel;

  factory ServiceListingModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceListingModelFromJson(json);

  ServiceListing toEntity() => ServiceListing(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
}
