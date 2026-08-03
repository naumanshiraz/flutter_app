import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';

abstract class FamilyMembersRepository {
  Future<Result<List<FamilyMember>>> getMembers();
  Future<Result<void>> addMember(FamilyMember member);
  Future<Result<void>> updateMember(FamilyMember member);
  Future<Result<void>> deleteMember(String id);
}
