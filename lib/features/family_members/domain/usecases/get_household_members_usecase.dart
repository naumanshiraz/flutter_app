import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/occupant.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_members_repository.dart';

class GetHouseholdMembersUseCase {
  final HouseholdMembersRepository _repository;
  const GetHouseholdMembersUseCase(this._repository);

  Future<Result<List<Occupant>>> call(String householdId) => _repository.getMembers(householdId);
}
