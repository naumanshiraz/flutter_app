import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/residency/data/datasources/residency_local_datasource.dart';
import 'package:pms_app/features/residency/data/datasources/residency_remote_datasource.dart';
import 'package:pms_app/features/residency/data/models/residency_address_model.dart';
import 'package:pms_app/features/residency/domain/entities/residency_address.dart';
import 'package:pms_app/features/residency/domain/repositories/residency_repository.dart';

class ResidencyRepositoryImpl implements ResidencyRepository {
  final ResidencyLocalDataSource _localDataSource;
  final ResidencyRemoteDataSource _remoteDataSource;

  ResidencyRepositoryImpl({
    required ResidencyLocalDataSource localDataSource,
    required ResidencyRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<Result<ResidencyAddress>> getCachedAddress() async {
    try {
      final model = _localDataSource.getCachedAddress();
      return Success(model.toEntity());
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load residency address: $e'));
    }
  }

  @override
  Future<Result<void>> saveAddress(ResidencyAddress address) async {
    try {
      final model = ResidencyAddressModel.fromEntity(address);
      await _remoteDataSource.saveAddress(model);
      await _localDataSource.saveAddress(model);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } on CacheException catch (e) {
      return ResultError(CacheFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to save residency address: $e'));
    }
  }
}
