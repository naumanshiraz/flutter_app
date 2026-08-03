import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';

part 'family_member_model.freezed.dart';
part 'family_member_model.g.dart';

@freezed
class FamilyMemberModel with _$FamilyMemberModel {
  const FamilyMemberModel._();

  const factory FamilyMemberModel({
    required String id,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    String? relationship,
    int? birthYear,
    String? gender,
  }) = _FamilyMemberModel;

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberModelFromJson(json);

  factory FamilyMemberModel.fromEntity(FamilyMember entity) => FamilyMemberModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        phone: entity.phone,
        relationship: entity.relationship,
        birthYear: entity.birthYear,
        gender: entity.gender,
      );

  FamilyMember toEntity() => FamilyMember(
        id: id,
        name: name,
        email: email,
        phone: phone,
        relationship: relationship,
        birthYear: birthYear,
        gender: gender,
      );
}
