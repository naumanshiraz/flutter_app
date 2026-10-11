import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/pets/data/models/pet_model.dart';

abstract class PetsRemoteDataSource {
  Future<List<PetModel>> getPets(String householdId);
  Future<void> addPet(String householdId, PetModel pet);
  Future<void> updatePet(String householdId, PetModel pet);
  Future<void> deletePet(String householdId, String petId);
}

class PetsRemoteDataSourceImpl implements PetsRemoteDataSource {
  final Dio _dio;

  PetsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PetModel>> getPets(String householdId) async {
    try {
      final response = await _dio.get(AppConstants.endpointHouseholdPets(householdId));
      final rows = response.data as List<dynamic>;
      return rows.map((row) => PetModel.fromJson(row as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to load pets.'));
    } catch (e) {
      throw ServerException('Unexpected error loading pets: $e');
    }
  }

  @override
  Future<void> addPet(String householdId, PetModel pet) async {
    try {
      await _dio.post(AppConstants.endpointHouseholdPets(householdId), data: pet.toRequestJson());
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to add pet.'));
    } catch (e) {
      throw ServerException('Unexpected error adding pet: $e');
    }
  }

  @override
  Future<void> updatePet(String householdId, PetModel pet) async {
    try {
      await _dio.patch(AppConstants.endpointHouseholdPet(householdId, pet.id), data: pet.toRequestJson());
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to update pet.'));
    } catch (e) {
      throw ServerException('Unexpected error updating pet: $e');
    }
  }

  @override
  Future<void> deletePet(String householdId, String petId) async {
    try {
      await _dio.delete(AppConstants.endpointHouseholdPet(householdId, petId));
    } on DioException catch (e) {
      throw ServerException(_message(e, 'Failed to delete pet.'));
    } catch (e) {
      throw ServerException('Unexpected error deleting pet: $e');
    }
  }

  String _message(DioException e, String fallback) {
    final data = e.response?.data;
    final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
    return serverMessage ?? e.message ?? fallback;
  }
}
