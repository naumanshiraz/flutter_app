import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/data/datasources/properties_remote_datasource.dart';
import 'package:pms_app/features/properties/data/models/property_model.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/domain/repositories/properties_repository.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final PropertiesRemoteDataSource _remoteDataSource;

  PropertiesRepositoryImpl({required PropertiesRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<AvailableSuite>>> getAvailableSuites(String campusId) async {
    try {
      final models = await _remoteDataSource.getAvailableSuites(campusId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load suites: $e'));
    }
  }

  @override
  Future<Result<void>> submitClaimRequest(String householdId) async {
    try {
      await _remoteDataSource.submitClaimRequest(householdId);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to submit request: $e'));
    }
  }

  @override
  Future<Result<void>> updateProperty(Property property) async {
    try {
      await _remoteDataSource.updateProperty(PropertyModel.fromEntity(property));
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update property: $e'));
    }
  }

  @override
  Future<Result<void>> deleteProperty(String id) async {
    try {
      await _remoteDataSource.deleteProperty(id);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete property: $e'));
    }
  }
}
