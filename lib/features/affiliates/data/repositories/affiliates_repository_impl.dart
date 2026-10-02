import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/affiliates/data/datasources/affiliates_remote_datasource.dart';
import 'package:pms_app/features/affiliates/data/models/affiliate_model.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/domain/repositories/affiliates_repository.dart';
import 'package:pms_app/features/main_home/domain/entities/household.dart';

class AffiliatesRepositoryImpl implements AffiliatesRepository {
  final AffiliatesRemoteDataSource remoteDataSource;

  AffiliatesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Affiliate>>> getAffiliates({String? householdId}) async {
    try {
      final models = await remoteDataSource.getAffiliates(householdId: householdId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load affiliates: $e'));
    }
  }

  @override
  Future<Result<void>> addOrUpdateAffiliate(Affiliate affiliate) async {
    try {
      await remoteDataSource.addOrUpdateAffiliate(AffiliateModel.fromEntity(affiliate));
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to save affiliate: $e'));
    }
  }

  @override
  Future<Result<void>> deleteAffiliate(String id) async {
    try {
      await remoteDataSource.deleteAffiliate(id);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete affiliate: $e'));
    }
  }

  @override
  Future<Result<List<Household>>> getAssignedHouseholds(String affiliateId) async {
    try {
      final models = await remoteDataSource.getAssignedHouseholds(affiliateId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load assigned properties: $e'));
    }
  }

  @override
  Future<Result<void>> removeHouseholdAccess({required String affiliateId, required String householdId}) async {
    try {
      await remoteDataSource.removeHouseholdAccess(affiliateId: affiliateId, householdId: householdId);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to remove access: $e'));
    }
  }
}
