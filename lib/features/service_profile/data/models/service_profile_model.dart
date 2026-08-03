import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pms_app/features/service_profile/domain/entities/service_profile.dart';

part 'service_profile_model.freezed.dart';
part 'service_profile_model.g.dart';

@freezed
class ServiceReplyModel with _$ServiceReplyModel {
  const ServiceReplyModel._();

  const factory ServiceReplyModel({
    required String authorInitial,
    required String authorName,
    required String text,
  }) = _ServiceReplyModel;

  factory ServiceReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceReplyModelFromJson(json);

  ServiceReply toEntity() => ServiceReply(
        authorInitial: authorInitial,
        authorName: authorName,
        text: text,
      );
}

@freezed
class ServiceCommentModel with _$ServiceCommentModel {
  const ServiceCommentModel._();

  const factory ServiceCommentModel({
    required String id,
    required String authorInitial,
    required String authorName,
    required String text,
    @Default([]) List<ServiceReplyModel> replies,
  }) = _ServiceCommentModel;

  factory ServiceCommentModel.fromJson(Map<String, dynamic> json) => _$ServiceCommentModelFromJson(json);

  ServiceComment toEntity() => ServiceComment(
    id: id,
    authorInitial: authorInitial, 
    authorName: authorName, 
    text: text,
    replies: replies.map((e) => e.toEntity()).toList(),

  );
}

@freezed
class ServiceProfileModel with _$ServiceProfileModel {
  const ServiceProfileModel._();

  const factory ServiceProfileModel({
    required String id,
    required String name,
    required String subtitle,
    required String heroImageUrl,
    required String tagline,
    required String description,
    required double rating,
    @Default(<ServiceCommentModel>[]) List<ServiceCommentModel> comments,
  }) = _ServiceProfileModel;

  factory ServiceProfileModel.fromJson(Map<String, dynamic> json) => _$ServiceProfileModelFromJson(json);

  ServiceProfile toEntity() => ServiceProfile(
        id: id,
        name: name,
        subtitle: subtitle,
        heroImageUrl: heroImageUrl,
        tagline: tagline,
        description: description,
        rating: rating,
        comments: comments.map((c) => c.toEntity()).toList(),
      );
}
