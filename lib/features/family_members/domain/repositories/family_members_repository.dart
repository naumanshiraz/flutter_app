import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';

/// Domain contract for the family members / affiliates list —
/// full CRUD, since this screen explicitly needs add/edit/delete.
abstract class FamilyMembersRepository {
  Future<Result<List<FamilyMember>>> getMembers();
  Future<Result<void>> addMember(FamilyMember member);
  Future<Result<void>> updateMember(FamilyMember member);
  Future<Result<void>> deleteMember(String id);
}
