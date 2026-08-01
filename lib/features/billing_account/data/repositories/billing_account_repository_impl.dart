import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/billing_account/data/datasources/billing_account_local_datasource.dart';
import 'package:pms_app/features/billing_account/data/datasources/billing_account_remote_datasource.dart';
import 'package:pms_app/features/billing_account/data/models/billing_account_model.dart';
import 'package:pms_app/features/billing_account/domain/entities/billing_account.dart';
import 'package:pms_app/features/billing_account/domain/repositories/billing_account_repository.dart';

class BillingAccountRepositoryImpl implements BillingAccountRepository {
  final BillingAccountLocalDataSource _localDataSource;
  final BillingAccountRemoteDataSource _remoteDataSource;

  BillingAccountRepositoryImpl({
    required BillingAccountLocalDataSource localDataSource,
    required BillingAccountRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<void>> submitBillingAccount(BillingAccount account) async {
    try {
      final model = BillingAccountModel.fromEntity(account);
      await _remoteDataSource.submitBillingAccount(model);
      await _localDataSource.persistBillingAccount(model);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to submit billing account: $e'));
    }
  }
}
