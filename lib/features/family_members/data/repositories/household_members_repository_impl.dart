import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/family_members/data/datasources/household_members_remote_datasource.dart';
import 'package:pms_app/features/family_members/domain/entities/occupant.dart';
import 'package:pms_app/features/family_members/domain/repositories/household_members_repository.dart';

class HouseholdMembersRepositoryImpl implements HouseholdMembersRepository {
  final HouseholdMembersRemoteDataSource remoteDataSource;

  const HouseholdMembersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Occupant>>> getMembers(String householdId) async {
    try {
      final models = await remoteDataSource.getMembers(householdId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load occupants: $e'));
    }
  }
}
