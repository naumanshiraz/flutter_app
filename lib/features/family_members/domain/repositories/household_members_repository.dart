import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/domain/entities/occupant.dart';

abstract class HouseholdMembersRepository {
  Future<Result<List<Occupant>>> getMembers(String householdId);
}
