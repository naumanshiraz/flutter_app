import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();

  const factory ChatMessageModel({
    required String id,
    required String senderName,
    required String senderInitials,
    required String text,
    required String timeLabel,
    required bool isMine,
    @Default(false) bool isRead,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  ChatMessage toEntity() => ChatMessage(
        id: id,
        senderName: senderName,
        senderInitials: senderInitials,
        text: text,
        timeLabel: timeLabel,
        isMine: isMine,
        isRead: isRead,
      );
}
