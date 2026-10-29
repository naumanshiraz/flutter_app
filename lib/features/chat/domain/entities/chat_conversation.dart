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
  final bool canPost;
  final bool isArchived;
  final String? projectId;
  final DateTime? lastMessageAt;

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
    this.canPost = true,
    this.isArchived = false,
    this.projectId,
    this.lastMessageAt,
  });

  ChatConversation copyWith({bool? isUnread}) => ChatConversation(
        id: id,
        title: title,
        avatarInitials: avatarInitials,
        avatarUrl: avatarUrl,
        lastMessageSender: lastMessageSender,
        lastMessagePreview: lastMessagePreview,
        timeLabel: timeLabel,
        isUnread: isUnread ?? this.isUnread,
        isGroup: isGroup,
        type: type,
        subscriberCount: subscriberCount,
        canPost: canPost,
        isArchived: isArchived,
        projectId: projectId,
        lastMessageAt: lastMessageAt,
      );

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
        canPost,
        isArchived,
        projectId,
        lastMessageAt,
      ];
}

