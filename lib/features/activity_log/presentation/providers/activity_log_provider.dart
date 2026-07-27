import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/activity_log/domain/entities/log_entry.dart';
import 'package:pms_app/features/activity_log/presentation/providers/activity_log_di_providers.dart';

enum LogFilter { all, missed }

class ActivityLogState {
  final bool isLoading;
  final List<LogEntry> logs;
  final LogFilter filter;
  final String? error;

  const ActivityLogState({
    this.isLoading = true,
    this.logs = const [],
    this.filter = LogFilter.all,
    this.error,
  });

  List<LogEntry> get visibleLogs =>
      filter == LogFilter.missed ? logs.where((l) => l.isMissed).toList() : logs;

  ActivityLogState copyWith({
    bool? isLoading,
    List<LogEntry>? logs,
    LogFilter? filter,
    String? error,
    bool clearError = false,
  }) {
    return ActivityLogState(
      isLoading: isLoading ?? this.isLoading,
      logs: logs ?? this.logs,
      filter: filter ?? this.filter,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ActivityLogNotifier extends StateNotifier<ActivityLogState> {
  final Ref _ref;

  ActivityLogNotifier(this._ref) : super(const ActivityLogState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final getLogs = _ref.read(getLogsUseCaseProvider);
    final result = await getLogs();
    result.when(
      onSuccess: (logs) => state = state.copyWith(isLoading: false, logs: logs, clearError: true),
      onFailure: (failure) => state = state.copyWith(isLoading: false, error: failure.message),
    );
  }

  void setFilter(LogFilter filter) => state = state.copyWith(filter: filter);

  Future<void> refresh() => _fetch();
}

final activityLogNotifierProvider =
    StateNotifierProvider.autoDispose<ActivityLogNotifier, ActivityLogState>(
  (ref) => ActivityLogNotifier(ref),
);
