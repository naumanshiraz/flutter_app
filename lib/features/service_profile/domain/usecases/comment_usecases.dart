import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/service_profile/domain/repositories/comment_repository.dart';

class PostCommentUseCase {
  final CommentRepository _repository;
  const PostCommentUseCase(this._repository);

  Future<Result<void>> call({required String serviceId, required String text}) =>
      _repository.postComment(serviceId: serviceId, text: text);
}

class PostReplyUseCase {
  final CommentRepository _repository;
  const PostReplyUseCase(this._repository);

  Future<Result<void>> call({required String serviceId, required String commentId, required String text}) =>
      _repository.postReply(serviceId: serviceId, commentId: commentId, text: text);
}
