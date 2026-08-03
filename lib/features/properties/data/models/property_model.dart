import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

@freezed
class PropertyModel with _$PropertyModel {
  const PropertyModel._();

  const factory PropertyModel({
    required String id,
    @Default('') String suite,
    String? floor,
    String? type,
    String? building,
  }) = _PropertyModel;

  factory PropertyModel.fromJson(Map<String, dynamic> json) => _$PropertyModelFromJson(json);

  factory PropertyModel.fromEntity(Property entity) => PropertyModel(
        id: entity.id,
        suite: entity.suite,
        floor: entity.floor,
        type: entity.type,
        building: entity.building,
      );

  Property toEntity() => Property(
        id: id,
        suite: suite,
        floor: floor,
        type: type,
        building: building,
      );
}
