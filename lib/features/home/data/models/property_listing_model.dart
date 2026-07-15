import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/home/domain/entities/property_listing.dart';

part 'property_listing_model.freezed.dart';
part 'property_listing_model.g.dart';

@freezed
class PropertyListingModel with _$PropertyListingModel {
  const PropertyListingModel._();

  const factory PropertyListingModel({
    required String id,
    required String title,
    required String managementCompany,
    required String imageUrl,
  }) = _PropertyListingModel;

  factory PropertyListingModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyListingModelFromJson(json);

  PropertyListing toEntity() => PropertyListing(
        id: id,
        title: title,
        managementCompany: managementCompany,
        imageUrl: imageUrl,
      );
}
