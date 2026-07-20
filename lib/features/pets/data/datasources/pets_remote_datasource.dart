import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/pets/data/models/pet_model.dart';

abstract class PetsRemoteDataSource {
  Future<void> addPet(PetModel pet);
  Future<void> updatePet(PetModel pet);
  Future<void> deletePet(String id);
}

class PetsRemoteDataSourceImpl implements PetsRemoteDataSource {
  final Dio _dio;

  PetsRemoteDataSourceImpl(this._dio);

  @override
  Future<void> addPet(PetModel pet) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.post('/user/pets', data: pet.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to add pet.');
    }
  }

  @override
  Future<void> updatePet(PetModel pet) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // await _dio.patch('/user/pets/${pet.id}', data: pet.toJson());
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to update pet.');
    }
  }

  @override
  Future<void> deletePet(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // await _dio.delete('/user/pets/$id');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete pet.');
    }
  }
}
