import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';

abstract class AffiliatesRepository {
  Future<Result<List<Affiliate>>> getAffiliates({String? propertyId});

  Future<Result<void>> addOrUpdateAffiliate(Affiliate affiliate);

  Future<Result<void>> deleteAffiliate(String id);
}
