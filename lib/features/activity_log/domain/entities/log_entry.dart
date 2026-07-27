import 'package:equatable/equatable.dart';

enum LogEntryKind { door, call }

class LogEntry extends Equatable {
  final String id;
  final String title;
  final String location;
  final String dateLabel;
  final LogEntryKind kind;
  final bool isMissed;

  const LogEntry({
    required this.id,
    required this.title,
    required this.location,
    required this.dateLabel,
    required this.kind,
    this.isMissed = false,
  });

  @override
  List<Object?> get props => [id, title, location, dateLabel, kind, isMissed];
}
