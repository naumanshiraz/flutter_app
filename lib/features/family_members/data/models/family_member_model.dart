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
    @Default('') String contact,
    String? relationship,
  }) = _FamilyMemberModel;

  factory FamilyMemberModel.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberModelFromJson(json);

  factory FamilyMemberModel.fromEntity(FamilyMember entity) => FamilyMemberModel(
        id: entity.id,
        name: entity.name,
        contact: entity.contact,
        relationship: entity.relationship,
      );

  FamilyMember toEntity() => FamilyMember(
        id: id,
        name: name,
        contact: contact,
        relationship: relationship,
      );
}
