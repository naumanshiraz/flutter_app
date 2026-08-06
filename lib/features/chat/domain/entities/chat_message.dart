import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String senderName;
  final String senderInitials;
  final String text;
  final String timeLabel;

  final bool isMine;

  final bool isRead;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.senderInitials,
    required this.text,
    required this.timeLabel,
    required this.isMine,
    this.isRead = false,
  });

  @override
  List<Object?> get props =>
      [id, senderName, senderInitials, text, timeLabel, isMine, isRead];
}
