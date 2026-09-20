import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/residency/data/models/campus_option_model.dart';
import 'package:pms_app/features/residency/data/models/residency_address_model.dart';

abstract class ResidencyRemoteDataSource {
  Future<void> saveAddress(ResidencyAddressModel address);

  Future<List<CampusOptionModel>> getCampuses({String query = ''});
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

  @override
  Future<List<CampusOptionModel>> getCampuses({String query = ''}) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointCampuses,
        queryParameters: {'q': query, 'limit': 50, 'offset': 0},
      );
      final rows = response.data as List<dynamic>;
      return rows.map((row) => CampusOptionModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load campuses.');
    } catch (e) {
      throw ServerException('Unexpected error loading campuses: $e');
    }
  }
}
