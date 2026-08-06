import 'package:equatable/equatable.dart';
import 'package:pms_app/features/chat/domain/entities/conversation_type.dart';

class ChatConversation extends Equatable {
  final String id;
  final String title;
  final String avatarInitials;
  final String? avatarUrl;
  final String? lastMessageSender;
  final String lastMessagePreview;
  final String timeLabel;
  final bool isUnread;
  final bool isGroup;
  final ConversationType type;
  final int subscriberCount;

  const ChatConversation({
    required this.id,
    required this.title,
    required this.avatarInitials,
    this.avatarUrl,
    this.lastMessageSender,
    required this.lastMessagePreview,
    required this.timeLabel,
    required this.isUnread,
    required this.isGroup,
    required this.type,
    this.subscriberCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        avatarInitials,
        avatarUrl,
        lastMessageSender,
        lastMessagePreview,
        timeLabel,
        isUnread,
        isGroup,
        type,
        subscriberCount,
      ];
}

