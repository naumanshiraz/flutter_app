import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/vehicles/domain/entities/vehicle.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
class VehicleModel with _$VehicleModel {
  const VehicleModel._();

  const factory VehicleModel({
    required String id,
    String? type,
    String? brand,
    String? engineType,
    @Default('') String licensePlate,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) => _$VehicleModelFromJson(json);

  factory VehicleModel.fromEntity(Vehicle entity) => VehicleModel(
        id: entity.id,
        type: entity.type,
        brand: entity.brand,
        engineType: entity.engineType,
        licensePlate: entity.licensePlate,
      );

  Vehicle toEntity() => Vehicle(
        id: id,
        type: type,
        brand: brand,
        engineType: engineType,
        licensePlate: licensePlate,
      );
}
