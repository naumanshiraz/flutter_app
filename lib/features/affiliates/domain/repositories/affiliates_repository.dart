import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

abstract class AffiliatesRepository {
  Future<Result<List<Affiliate>>> getAffiliates({String? householdId});

  Future<Result<void>> addOrUpdateAffiliate(Affiliate affiliate);

  Future<Result<void>> deleteAffiliate(String id);

  Future<Result<List<Household>>> getAssignedHouseholds(String affiliateId);

  Future<Result<void>> removeHouseholdAccess({required String affiliateId, required String householdId});
}
