import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

String? _label(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  if (value.toLowerCase() == 'suv') return 'SUV';
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}

@freezed
class VehicleModel with _$VehicleModel {
  const VehicleModel._();

  const factory VehicleModel({
    required String id,
    @JsonKey(name: 'body_type') String? type,
    String? brand,
    @JsonKey(name: 'engine_type') String? engineType,
    @JsonKey(name: 'license_plate') @Default('') String licensePlate,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => _$VehicleModelFromJson(json);

  factory VehicleModel.fromEntity(Vehicle entity) => VehicleModel(
        id: entity.id,
        type: entity.type,
        brand: entity.brand,
        engineType: entity.engineType,
        licensePlate: entity.licensePlate,
      );

  Map<String, dynamic> toRequestJson() => {
        'body_type': type?.toLowerCase(),
        'brand': brand,
        'engine_type': engineType?.toLowerCase(),
        'license_plate': licensePlate,
      };

  Vehicle toEntity() => Vehicle(
        id: id,
        type: _label(type),
        brand: brand,
        engineType: _label(engineType),
        licensePlate: licensePlate,
      );
}
