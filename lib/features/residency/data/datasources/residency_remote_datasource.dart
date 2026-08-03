import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/residency/data/models/residency_address_model.dart';

abstract class ResidencyRemoteDataSource {
  Future<void> saveAddress(ResidencyAddressModel address);
}

class ResidencyRemoteDataSourceImpl implements ResidencyRemoteDataSource {
  final Dio _dio;

  ResidencyRemoteDataSourceImpl(this._dio);

  @override
  Future<void> saveAddress(ResidencyAddressModel address) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));

      // ---- REAL API (uncomment once the backend exists) ---------------
      // await _dio.patch('/user/residency', data: address.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to save residency address.');
    } catch (e) {
      throw ServerException('Unexpected error saving residency address: $e');
    }
  }
}
