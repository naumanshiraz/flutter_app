import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/property_detail/domain/entities/property_detail.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

part 'property_detail_model.freezed.dart';
part 'property_detail_model.g.dart';

@freezed
class PropertyDetailModel with _$PropertyDetailModel {
  const PropertyDetailModel._();

  const factory PropertyDetailModel({
    required String id,
    required String name,
    required String address,
    @Default(<String>[]) List<String> heroImageUrls,
    @Default('grid') String servicesLayout,
  }) = _PropertyDetailModel;

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyDetailModelFromJson(json);

  factory PropertyDetailModel.fromHouseholdJson(Map<String, dynamic> json) {
    final buildingAddress = json['building_address'] as Map<String, dynamic>?;
    final developmentAddress = json['development_address'] as Map<String, dynamic>?;
    final address = buildingAddress ?? developmentAddress;

    final addressParts = [
      address?['address_line_1'],
      address?['city'],
      address?['country'],
    ].whereType<String>().where((p) => p.trim().isNotEmpty).toList();

    final buildingThumbUrl = json['building_thumb_url'] as String?;
    final developmentThumbUrl = json['development_thumb_url'] as String?;
    final thumb = (buildingThumbUrl != null && buildingThumbUrl.trim().isNotEmpty)
        ? buildingThumbUrl
        : developmentThumbUrl;

    return PropertyDetailModel(
      id: json['household_id'] as String? ?? '',
      name: (json['building_name'] as String?) ?? (json['development_name'] as String?) ?? '',
      address: addressParts.join(', '),
      heroImageUrls: (thumb == null || thumb.trim().isEmpty) ? const [] : [thumb],
    );
  }

  PropertyDetail toEntity() => PropertyDetail(
        id: id,
        name: name,
        address: address,
        heroImageUrls: heroImageUrls,
        servicesLayout: servicesGridLayoutFromApiValue(servicesLayout),
      );
}
