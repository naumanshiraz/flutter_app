import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';
import 'package:pms_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl({required HomeRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<ProfileSummary>> getProfileSummary() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return Success(model.toEntity());
    } on UnauthorizedException catch (e) {
      return ResultError(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load profile: $e'));
    }
  }
}
