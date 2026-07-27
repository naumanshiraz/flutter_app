import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/activity_log/domain/entities/log_entry.dart';

abstract class ActivityLogRepository {
  Future<Result<List<LogEntry>>> getLogs();
}
