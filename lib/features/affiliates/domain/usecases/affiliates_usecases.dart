import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

class GetAffiliatesUseCase {
  final AffiliatesRepository _repository;
  const GetAffiliatesUseCase(this._repository);

  Future<Result<List<Affiliate>>> call({String? householdId}) =>
      _repository.getAffiliates(householdId: householdId);
}

class AddOrUpdateAffiliateUseCase {
  final AffiliatesRepository _repository;
  const AddOrUpdateAffiliateUseCase(this._repository);

  Future<Result<void>> call(Affiliate affiliate) => _repository.addOrUpdateAffiliate(affiliate);
}

class DeleteAffiliateUseCase {
  final AffiliatesRepository _repository;
  const DeleteAffiliateUseCase(this._repository);

  Future<Result<void>> call(String id) => _repository.deleteAffiliate(id);
}

class GetAssignedHouseholdsUseCase {
  final AffiliatesRepository _repository;
  const GetAssignedHouseholdsUseCase(this._repository);

  Future<Result<List<Household>>> call(String affiliateId) => _repository.getAssignedHouseholds(affiliateId);
}

class RemoveHouseholdAccessUseCase {
  final AffiliatesRepository _repository;
  const RemoveHouseholdAccessUseCase(this._repository);

  Future<Result<void>> call({required String affiliateId, required String householdId}) =>
      _repository.removeHouseholdAccess(affiliateId: affiliateId, householdId: householdId);
}
