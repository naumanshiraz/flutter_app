import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';

part 'editable_profile_model.freezed.dart';
part 'editable_profile_model.g.dart';

/// Data-layer shape of the editable profile — exactly the body a real
/// `PATCH /user/profile` would send once a backend exists.
@freezed
class EditableProfileModel with _$EditableProfileModel {
  const EditableProfileModel._();

  const factory EditableProfileModel({
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    String? country,
    DateTime? birthDate,
    String? pronouns,
    String? avatarPath,
  }) = _EditableProfileModel;

  factory EditableProfileModel.fromJson(Map<String, dynamic> json) =>
      _$EditableProfileModelFromJson(json);

  factory EditableProfileModel.fromEntity(EditableProfile entity) => EditableProfileModel(
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        country: entity.country,
        birthDate: entity.birthDate,
        pronouns: entity.pronouns,
        avatarPath: entity.avatarPath,
      );

  EditableProfile toEntity() => EditableProfile(
        name: name,
        email: email,
        phone: phone,
        country: country,
        birthDate: birthDate,
        pronouns: pronouns,
        avatarPath: avatarPath,
      );
}
