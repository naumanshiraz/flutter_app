import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/activity_log/data/models/log_entry_model.dart';

abstract class ActivityLogLocalDataSource {
  Future<List<LogEntryModel>> fetchLogs();
}

class ActivityLogLocalDataSourceImpl implements ActivityLogLocalDataSource {
  @override
  Future<List<LogEntryModel>> fetchLogs() async {
    try {
      await Future.delayed(const Duration(milliseconds: 150));
      return const [
        LogEntryModel(id: '1', title: 'Entrance Door', location: 'Gerlug Vista, UB', dateLabel: 'Yesterday'),
      ];
    } catch (e) {
      throw CacheException('Failed to read cached logs: $e');
    }
  }
}
