import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const ChatMessageModel._();

  const factory ChatMessageModel({
    required String id,
    @JsonKey(name: 'group_id') String? groupId,
    @JsonKey(name: 'sender_id') @Default('') String senderId,
    @JsonKey(name: 'sender_name') @Default('') String senderName,
    @JsonKey(name: 'sender_pic_url') String? senderPicUrl,
    @JsonKey(name: 'parent_id') String? parentId,
    @Default('') String content,
    @JsonKey(name: 'sent_at') String? sentAt,
    @JsonKey(name: 'attachment') Map<String, dynamic>? attachment,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  DateTime? get sentAtDate => DateTime.tryParse(sentAt ?? '');

  ChatMessage toEntity({required bool isMine}) => ChatMessage(
        id: id,
        senderName: senderName,
        senderInitials: _initials(senderName),
        text: content,
        timeLabel: _timeLabel(sentAtDate),
        senderAvatarUrl: senderPicUrl,
        isMine: isMine,
      );

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return (parts.first[0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
  }

  static String _timeLabel(DateTime? utc) {
    if (utc == null) return '';
    final local = utc.toLocal();
    final now = DateTime.now();
    final sameDay = local.year == now.year && local.month == now.month && local.day == now.day;
    return sameDay ? DateFormat('HH:mm').format(local) : DateFormat('d/M').format(local);
  }
}
