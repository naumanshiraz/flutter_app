import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/billing_account/data/models/billing_account_model.dart';

abstract class BillingAccountRemoteDataSource {
  Future<void> submitBillingAccount(BillingAccountModel model);
}

class BillingAccountRemoteDataSourceImpl implements BillingAccountRemoteDataSource {
  final Dio _dio;
  BillingAccountRemoteDataSourceImpl(this._dio);

  @override
  Future<void> submitBillingAccount(BillingAccountModel model) async {
    try {
      // MOCK: no backend yet, just simulate a round-trip.
      await Future.delayed(const Duration(milliseconds: 500));
      return;

      // REAL API (uncomment once available)
      // await _dio.post('/billing-accounts', data: model.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to submit billing account.');
    } catch (e) {
      throw ServerException('Unexpected error submitting billing account: $e');
    }
  }
}
