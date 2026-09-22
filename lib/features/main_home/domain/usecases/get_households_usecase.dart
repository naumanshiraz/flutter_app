import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';
import 'package:pms_app/features/main_home/domain/repositories/household_repository.dart';

class GetHouseholdsUseCase {
  final HouseholdRepository _repository;
  const GetHouseholdsUseCase(this._repository);

  Future<Result<List<Household>>> call({
    required String campusId,
    String query = '',
    int limit = 50,
    int offset = 0,
  }) {
    return _repository.getHouseholds(
      campusId: campusId,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
