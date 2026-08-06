import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/conversation_type.dart';

part 'chat_conversation_model.freezed.dart';
part 'chat_conversation_model.g.dart';

@freezed
class ChatConversationModel with _$ChatConversationModel {
  const ChatConversationModel._();

  const factory ChatConversationModel({
    required String id,
    required String title,
    required String avatarInitials,
    String? avatarUrl,
    String? lastMessageSender,
    required String lastMessagePreview,
    required String timeLabel,
    required bool isUnread,
    required bool isGroup,
    @Default('announcement') String type,
    @Default(0) int subscriberCount,
  }) = _ChatConversationModel;

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationModelFromJson(json);

  ChatConversation toEntity() => ChatConversation(
        id: id,
        title: title,
        avatarInitials: avatarInitials,
        avatarUrl: avatarUrl,
        lastMessageSender: lastMessageSender,
        lastMessagePreview: lastMessagePreview,
        timeLabel: timeLabel,
        isUnread: isUnread,
        isGroup: isGroup,
        type: type == 'publicGroup' ? ConversationType.publicGroup : ConversationType.announcement,
        subscriberCount: subscriberCount,
      );
}
