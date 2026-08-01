import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/payment/data/datasources/payment_local_datasource.dart';
import 'package:pms_app/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:pms_app/features/payment/domain/entities/payment_method.dart';
import 'package:pms_app/features/payment/domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource _localDataSource;
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl({
    required PaymentLocalDataSource localDataSource,
    required PaymentRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<PaymentMethod>>> getPaymentMethods() async {
    try {
      final models = await _remoteDataSource.getPaymentMethods();
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (_) {
      try {
        final local = await _localDataSource.fetchPaymentMethods();
        return Success(local.map((m) => m.toEntity()).toList());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load payment methods: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load payment methods: $e'));
    }
  }
}
