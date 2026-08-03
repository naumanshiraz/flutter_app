import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/bank_transaction/data/datasources/bank_transaction_remote_datasource.dart';
import 'package:pms_app/features/bank_transaction/domain/entities/bank_transaction_detail.dart';
import 'package:pms_app/features/bank_transaction/domain/repositories/bank_transaction_repository.dart';

class BankTransactionRepositoryImpl implements BankTransactionRepository {
  final BankTransactionRemoteDataSource _remoteDataSource;
  BankTransactionRepositoryImpl({required BankTransactionRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<BankTransactionDetail>> getBankTransactionDetail(String paymentMethodId) async {
    try {
      final model = await _remoteDataSource.getBankTransactionDetail(paymentMethodId);
      return Success(model.toEntity());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load bank transaction detail: $e'));
    }
  }
}
