import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/data/datasources/household_remote_datasource.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';
import 'package:pms_app/features/main_home/domain/repositories/household_repository.dart';

class HouseholdRepositoryImpl implements HouseholdRepository {
  final HouseholdRemoteDataSource remoteDataSource;

  HouseholdRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Household>>> getHouseholds({
    required String campusId,
    String query = '',
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final models = await remoteDataSource.getHouseholds(
        campusId: campusId,
        query: query,
        limit: limit,
        offset: offset,
      );
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load households: $e'));
    }
  }
}
