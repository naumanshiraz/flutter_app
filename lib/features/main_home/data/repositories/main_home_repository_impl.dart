import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/main_home/data/datasources/main_home_remote_datasource.dart';
import 'package:pms_app/features/main_home/domain/entities/control.dart';
import 'package:pms_app/features/main_home/domain/repositories/main_home_repository.dart';

class MainHomeRepositoryImpl implements MainHomeRepository {
  final MainHomeRemoteDataSource remoteDataSource;

  MainHomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Control>>> getControls({String? householdId}) async {
    try {
      final remoteModels = await remoteDataSource.getControls(householdId: householdId);
      return Success(remoteModels.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load controls: $e'));
    }
  }

  @override
  Future<Result<void>> toggleControl(String id, bool newState) async {
    try {
      await remoteDataSource.toggleControl(id, newState);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to toggle control: $e'));
    }
  }
}
