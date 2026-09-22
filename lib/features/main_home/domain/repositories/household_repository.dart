import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

abstract class HouseholdRepository {
  Future<Result<List<Household>>> getHouseholds({
    required String campusId,
    String query = '',
    int limit = 50,
    int offset = 0,
  });
}
