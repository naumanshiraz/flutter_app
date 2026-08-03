import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/service_profile/data/datasources/service_profile_remote_datasource.dart';
import 'package:pms_app/features/service_profile/domain/entities/service_profile.dart';
import 'package:pms_app/features/service_profile/domain/repositories/service_profile_repository.dart';

class ServiceProfileRepositoryImpl implements ServiceProfileRepository {
  final ServiceProfileRemoteDataSource _remoteDataSource;
  ServiceProfileRepositoryImpl({required ServiceProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<ServiceProfile>> getServiceProfile(String serviceId) async {
    try {
      final model = await _remoteDataSource.getServiceProfile(serviceId);
      return Success(model.toEntity());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load service profile: $e'));
    }
  }
}
