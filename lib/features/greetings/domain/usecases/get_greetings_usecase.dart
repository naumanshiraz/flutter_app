import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/greetings/domain/entities/greeting.dart';
import 'package:pms_app/features/greetings/domain/repositories/greetings_repository.dart';

class GetGreetingsUseCase {
  final GreetingsRepository _repository;
  const GetGreetingsUseCase(this._repository);

  Future<Result<List<Greeting>>> call() => _repository.getGreetings();
}
