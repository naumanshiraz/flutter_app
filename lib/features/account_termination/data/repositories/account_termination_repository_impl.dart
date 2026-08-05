import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/account_termination/data/datasources/account_termination_remote_datasource.dart';
import 'package:pms_app/features/account_termination/domain/repositories/account_termination_repository.dart';

class AccountTerminationRepositoryImpl implements AccountTerminationRepository {
  final AccountTerminationRemoteDataSource _remoteDataSource;

  AccountTerminationRepositoryImpl({required AccountTerminationRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<void>> terminateAccount({required String reason, required String feedback}) async {
    try {
      await _remoteDataSource.terminateAccount(reason: reason, feedback: feedback);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to terminate account: $e'));
    }
  }
}
