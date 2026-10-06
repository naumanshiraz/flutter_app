import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/family_members/domain/entities/occupant.dart';

part 'occupant_model.freezed.dart';
part 'occupant_model.g.dart';

@freezed
class OccupantModel with _$OccupantModel {
  const OccupantModel._();

  const factory OccupantModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    String? relation,
    @JsonKey(name: 'can_use_devices') @Default(false) bool canUseDevices,
    @JsonKey(name: 'moved_in_at') String? movedInAt,
    @JsonKey(name: 'sponsored_by_me') @Default(false) bool sponsoredByMe,
  }) = _OccupantModel;

  factory OccupantModel.fromJson(Map<String, dynamic> json) => _$OccupantModelFromJson(json);

  Occupant toEntity() => Occupant(
        userId: userId,
        fullName: fullName,
        isPrimary: isPrimary,
        relation: relation,
        canUseDevices: canUseDevices,
        movedInAt: movedInAt == null ? null : DateTime.tryParse(movedInAt!),
        sponsoredByMe: sponsoredByMe,
      );
}
