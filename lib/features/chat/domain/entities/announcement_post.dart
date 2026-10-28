import 'package:equatable/equatable.dart';

/// One post in a group's read-only announcement feed.
class AnnouncementPost extends Equatable {
  final String id;
  final String authorName;
  final String authorSubtitle;
  final String authorInitials;
  final String? authorAvatarUrl;
  final String body;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;
  final String? attachmentName;
  final String? attachmentContentType;

  const AnnouncementPost({
    required this.id,
    required this.authorName,
    required this.authorSubtitle,
    required this.authorInitials,
    this.authorAvatarUrl,
    required this.body,
    this.imageUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.attachmentName,
    this.attachmentContentType,
  });

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorSubtitle,
        authorInitials,
        authorAvatarUrl,
        body,
        imageUrl,
        likeCount,
        commentCount,
        attachmentName,
        attachmentContentType,
      ];
}
