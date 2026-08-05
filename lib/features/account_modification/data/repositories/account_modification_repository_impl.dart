import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/account_modification/data/datasources/account_modification_remote_datasource.dart';
import 'package:pms_app/features/account_modification/domain/repositories/account_modification_repository.dart';

class AccountModificationRepositoryImpl implements AccountModificationRepository {
  final AccountModificationRemoteDataSource _remoteDataSource;

  AccountModificationRepositoryImpl({required AccountModificationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<void>> updateAdminIdentifier({required String currentIdentifier, required String newIdentifier}) async {
    try {
      await _remoteDataSource.updateAdminIdentifier(
        currentIdentifier: currentIdentifier,
        newIdentifier: newIdentifier,
      );
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update admin account: $e'));
    }
  }
}
