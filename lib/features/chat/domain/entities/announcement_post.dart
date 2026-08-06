import 'package:equatable/equatable.dart';

/// One post in a group's read-only announcement feed.
class AnnouncementPost extends Equatable {
  final String id;
  final String authorName;
  final String authorSubtitle;
  final String authorInitials;
  final String body;
  final String? imageUrl;
  final int likeCount;
  final int commentCount;

  const AnnouncementPost({
    required this.id,
    required this.authorName,
    required this.authorSubtitle,
    required this.authorInitials,
    required this.body,
    this.imageUrl,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  List<Object?> get props =>
      [id, authorName, authorSubtitle, authorInitials, body, imageUrl, likeCount, commentCount];
}
