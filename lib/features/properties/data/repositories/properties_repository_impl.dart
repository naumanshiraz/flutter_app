import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/properties/data/datasources/properties_local_datasource.dart';
import 'package:pms_app/features/properties/data/datasources/properties_remote_datasource.dart';
import 'package:pms_app/features/properties/data/models/property_model.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/domain/repositories/properties_repository.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final PropertiesLocalDataSource _localDataSource;
  final PropertiesRemoteDataSource _remoteDataSource;

  PropertiesRepositoryImpl({
    required PropertiesLocalDataSource localDataSource,
    required PropertiesRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<Property>>> getProperties() async {
    try {
      final models = _localDataSource.getProperties();
      return Success(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load properties: $e'));
    }
  }

  @override
  Future<Result<void>> addProperty(Property property) async {
    try {
      final model = PropertyModel.fromEntity(property);
      await _remoteDataSource.addProperty(model);

      final current = _localDataSource.getProperties();
      await _localDataSource.saveProperties([...current, model]);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to add property: $e'));
    }
  }

  @override
  Future<Result<void>> updateProperty(Property property) async {
    try {
      final model = PropertyModel.fromEntity(property);
      await _remoteDataSource.updateProperty(model);

      final current = _localDataSource.getProperties();
      final updated = current.map((p) => p.id == model.id ? model : p).toList();
      await _localDataSource.saveProperties(updated);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to update property: $e'));
    }
  }

  @override
  Future<Result<void>> deleteProperty(String id) async {
    try {
      await _remoteDataSource.deleteProperty(id);

      final current = _localDataSource.getProperties();
      final updated = current.where((p) => p.id != id).toList();
      await _localDataSource.saveProperties(updated);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to delete property: $e'));
    }
  }
}
