import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/greetings/domain/entities/greeting.dart';

abstract class GreetingsRepository {
  Future<Result<List<Greeting>>> getGreetings();
}
