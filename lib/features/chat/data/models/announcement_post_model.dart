import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';

part 'announcement_post_model.freezed.dart';
part 'announcement_post_model.g.dart';

@freezed
class AnnouncementPostModel with _$AnnouncementPostModel {
  const AnnouncementPostModel._();

  const factory AnnouncementPostModel({
    required String id,
    required String authorName,
    required String authorSubtitle,
    required String authorInitials,
    required String body,
    String? imageUrl,
    required int likeCount,
    required int commentCount,
  }) = _AnnouncementPostModel;

  factory AnnouncementPostModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementPostModelFromJson(json);

  AnnouncementPost toEntity() => AnnouncementPost(
        id: id,
        authorName: authorName,
        authorSubtitle: authorSubtitle,
        authorInitials: authorInitials,
        body: body,
        imageUrl: imageUrl,
        likeCount: likeCount,
        commentCount: commentCount,
      );
}
