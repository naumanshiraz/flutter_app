import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/properties/data/models/property_model.dart';

abstract class PropertiesRemoteDataSource {
  Future<void> addProperty(PropertyModel property);
  Future<void> updateProperty(PropertyModel property);
  Future<void> deleteProperty(String id);
}

class PropertiesRemoteDataSourceImpl implements PropertiesRemoteDataSource {
  final Dio _dio;

  PropertiesRemoteDataSourceImpl(this._dio);

  @override
  Future<void> addProperty(PropertyModel property) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.post('/user/properties', data: property.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to add property.');
    } catch (e) {
      throw ServerException('Unexpected error adding property: $e');
    }
  }

  @override
  Future<void> updateProperty(PropertyModel property) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.patch('/user/properties/${property.id}', data: property.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update property.');
    } catch (e) {
      throw ServerException('Unexpected error updating property: $e');
    }
  }

  @override
  Future<void> deleteProperty(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // await _dio.delete('/user/properties/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete property.');
    } catch (e) {
      throw ServerException('Unexpected error deleting property: $e');
    }
  }
}
