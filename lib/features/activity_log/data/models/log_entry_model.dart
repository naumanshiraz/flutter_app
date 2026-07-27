import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/activity_log/domain/entities/log_entry.dart';

part 'log_entry_model.freezed.dart';
part 'log_entry_model.g.dart';

@freezed
class LogEntryModel with _$LogEntryModel {
  const LogEntryModel._();

  const factory LogEntryModel({
    required String id,
    required String title,
    required String location,
    required String dateLabel,
    @Default('door') String kind,
    @Default(false) bool isMissed,
  }) = _LogEntryModel;

  factory LogEntryModel.fromJson(Map<String, dynamic> json) => _$LogEntryModelFromJson(json);

  LogEntry toEntity() => LogEntry(
        id: id,
        title: title,
        location: location,
        dateLabel: dateLabel,
        kind: kind == 'call' ? LogEntryKind.call : LogEntryKind.door,
        isMissed: isMissed,
      );
}
