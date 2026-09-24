import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/greetings/data/datasources/greetings_remote_datasource.dart';
import 'package:pms_app/features/greetings/domain/entities/greeting.dart';
import 'package:pms_app/features/greetings/domain/repositories/greetings_repository.dart';

class GreetingsRepositoryImpl implements GreetingsRepository {
  final GreetingsRemoteDataSource remoteDataSource;

  GreetingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<Greeting>>> getGreetings() async {
    try {
      final models = await remoteDataSource.getGreetings();
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load greetings: $e'));
    }
  }
}
