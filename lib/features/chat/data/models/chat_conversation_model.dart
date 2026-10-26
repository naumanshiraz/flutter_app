import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/conversation_type.dart';

part 'chat_conversation_model.freezed.dart';
part 'chat_conversation_model.g.dart';

@freezed
class ChatConversationModel with _$ChatConversationModel {
  const ChatConversationModel._();

  const factory ChatConversationModel({
    required String id,
    @JsonKey(name: 'group_name') @Default('') String groupName,
    String? description,
    @JsonKey(name: 'group_icon_url') String? groupIconUrl,
    @Default('public') String kind,
    @JsonKey(name: 'project_id') String? projectId,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'last_read_at') String? lastReadAt,
    @JsonKey(name: 'last_message_at') String? lastMessageAt,
    @JsonKey(name: 'is_unread') @Default(false) bool isUnread,
    @JsonKey(name: 'can_post') @Default(false) bool canPost,
  }) = _ChatConversationModel;

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationModelFromJson(json);

  ChatConversation toEntity() {
    final isAnnouncement = kind == 'announcement';
    final lastAt = DateTime.tryParse(lastMessageAt ?? '') ?? DateTime.tryParse(createdAt ?? '');
    final desc = description?.trim();

    return ChatConversation(
      id: id,
      title: groupName,
      avatarInitials: _initials(groupName),
      avatarUrl: groupIconUrl,
      lastMessageSender: null,
      // API has no message preview yet — fall back to description / kind label.
      lastMessagePreview: (desc != null && desc.isNotEmpty)
          ? desc
          : (isAnnouncement ? 'Announcements' : 'Public group'),
      timeLabel: _timeLabel(lastAt),
      isUnread: isUnread,
      isGroup: kind != 'direct',
      type: isAnnouncement ? ConversationType.announcement : ConversationType.publicGroup,
      canPost: canPost,
      isArchived: isArchived,
      projectId: projectId,
      lastMessageAt: lastAt,
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  static String _timeLabel(DateTime? utc) {
    if (utc == null) return '';
    final local = utc.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final diff = today.difference(day).inDays;
    if (diff <= 0) return DateFormat('HH:mm').format(local);
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEE').format(local);
    return DateFormat('dd/MM/yy').format(local);
  }
}
