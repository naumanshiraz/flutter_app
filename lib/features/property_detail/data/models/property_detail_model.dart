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

  PropertyDetail toEntity() => PropertyDetail(
        id: id,
        name: name,
        address: address,
        heroImageUrls: heroImageUrls,
        servicesLayout: servicesGridLayoutFromApiValue(servicesLayout),
      );
}
