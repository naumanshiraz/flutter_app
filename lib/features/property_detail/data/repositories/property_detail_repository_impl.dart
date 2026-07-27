import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/property_detail/data/datasources/property_detail_local_datasource.dart';
import 'package:pms_app/features/property_detail/data/datasources/property_detail_remote_datasource.dart';
import 'package:pms_app/features/property_detail/domain/entities/property_detail.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';
import 'package:pms_app/features/property_detail/domain/repositories/property_detail_repository.dart';

class PropertyDetailRepositoryImpl implements PropertyDetailRepository {
  final PropertyDetailLocalDataSource _localDataSource;
  final PropertyDetailRemoteDataSource _remoteDataSource;

  PropertyDetailRepositoryImpl({
    required PropertyDetailLocalDataSource localDataSource,
    required PropertyDetailRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<PropertyDetail>> getPropertyDetail(String propertyId) async {
    try {
      final model = await _remoteDataSource.getPropertyDetail(propertyId);
      return Success(model.toEntity());
    } on ServerException catch (_) {
      try {
        final local = await _localDataSource.fetchPropertyDetail(propertyId);
        return Success(local.toEntity());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load property detail: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load property detail: $e'));
    }
  }

  @override
  Future<Result<List<ServiceListing>>> getServices(String propertyId) async {
    try {
      final models = await _remoteDataSource.getServices(propertyId);
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (_) {
      try {
        final local = await _localDataSource.fetchServices(propertyId);
        return Success(local.map((m) => m.toEntity()).toList());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load services: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load services: $e'));
    }
  }
}
