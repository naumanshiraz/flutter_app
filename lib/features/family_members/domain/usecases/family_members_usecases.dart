import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/family_member.dart';
import 'package:pms_app/features/family_members/domain/repositories/family_members_repository.dart';

class GetFamilyMembersUseCase {
  final FamilyMembersRepository _repository;
  const GetFamilyMembersUseCase(this._repository);

  Future<Result<List<FamilyMember>>> call() => _repository.getMembers();
}

class AddFamilyMemberUseCase {
  final FamilyMembersRepository _repository;
  const AddFamilyMemberUseCase(this._repository);

  Future<Result<void>> call(FamilyMember member) => _repository.addMember(member);
}

class UpdateFamilyMemberUseCase {
  final FamilyMembersRepository _repository;
  const UpdateFamilyMemberUseCase(this._repository);

  Future<Result<void>> call(FamilyMember member) => _repository.updateMember(member);
}

class DeleteFamilyMemberUseCase {
  final FamilyMembersRepository _repository;
  const DeleteFamilyMemberUseCase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteMember(id);
}
