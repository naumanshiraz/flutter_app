import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/activity_log/domain/entities/log_entry.dart';
import 'package:pms_app/features/activity_log/domain/repositories/activity_log_repository.dart';

class GetLogsUseCase {
  final ActivityLogRepository _repository;
  const GetLogsUseCase(this._repository);

  Future<Result<List<LogEntry>>> call() => _repository.getLogs();
}
