import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/data/datasources/main_home_local_datasource.dart';
import 'package:pms_app/features/main_home/data/datasources/main_home_remote_datasource.dart';
import 'package:pms_app/features/main_home/data/models/control_model.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';
import 'package:pms_app/features/main_home/domain/repositories/main_home_repository.dart';

class MainHomeRepositoryImpl implements MainHomeRepository {
  final MainHomeLocalDataSource localDataSource;
  final MainHomeRemoteDataSource remoteDataSource;

  MainHomeRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Result<List<Control>>> getControls({String? propertyId}) async {
    try {
      // Prefer remote (mocked) but fall back to local if remote fails.
      final remoteModels = await remoteDataSource.getControls(propertyId: propertyId);
      final entities = remoteModels.map((m) => m.toEntity()).toList();
      return Success(entities);
    } on ServerException {
      // Try local fallback
      try {
        final local = await localDataSource.fetchControls();
        return Success(local.map((m) => m.toEntity()).toList());
      } on CacheException catch (e2) {
        return ResultError(CacheFailure(e2.message));
      } catch (e) {
        return ResultError(UnknownFailure('Failed to load controls: $e'));
      }
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load controls: $e'));
    }
  }

  @override
  Future<Result<void>> toggleControl(String id, bool newState) async {
    try {
      // Optimistic: ask remote to toggle (mock), persist locally
      await remoteDataSource.toggleControl(id, newState);
      await localDataSource.persistToggle(id, newState);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to toggle control: $e'));
    }
  }
}