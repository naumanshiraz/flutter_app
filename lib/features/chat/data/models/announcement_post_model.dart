import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';

part 'announcement_post_model.freezed.dart';
part 'announcement_post_model.g.dart';

@freezed
class AnnouncementPostModel with _$AnnouncementPostModel {
  const AnnouncementPostModel._();

  const factory AnnouncementPostModel({
    required String id,
    @JsonKey(name: 'sender_name') @Default('') String senderName,
    @JsonKey(name: 'sender_pic_url') String? senderPicUrl,
    @Default('') String content,
    @JsonKey(name: 'sent_at') String? sentAt,
    @JsonKey(name: 'attachment') Map<String, dynamic>? attachment,
    // Not provided by the API yet — default to 0.
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
  }) = _AnnouncementPostModel;

  factory AnnouncementPostModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementPostModelFromJson(json);

  DateTime? get sentAtDate => DateTime.tryParse(sentAt ?? '');

  AnnouncementPost toEntity() {
    final at = sentAtDate?.toLocal();
    final name = attachment?['name']?.toString();
    return AnnouncementPost(
      id: id,
      authorName: senderName,
      authorSubtitle: at == null ? '' : DateFormat('d MMM y, HH:mm').format(at),
      authorInitials: _initials(senderName),
      authorAvatarUrl: senderPicUrl,
      body: content,
      likeCount: likeCount,
      commentCount: commentCount,
      attachmentName: (name != null && name.isNotEmpty) ? name : null,
      attachmentContentType: attachment?['content_type']?.toString(),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return (parts.first[0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
  }
}
