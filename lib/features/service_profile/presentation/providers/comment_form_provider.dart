import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/service_profile/presentation/providers/comment_di_providers.dart';

enum CommentSubmitStatus { idle, submitting, success, error }

class CommentFormState {
  final CommentSubmitStatus status;
  final String? error;

  const CommentFormState({this.status = CommentSubmitStatus.idle, this.error});
}

class CommentFormNotifier extends StateNotifier<CommentFormState> {
  final Ref _ref;
  CommentFormNotifier(this._ref) : super(const CommentFormState());

  Future<void> submitComment({required String serviceId, required String text}) async {
    state = const CommentFormState(status: CommentSubmitStatus.submitting);
    final postComment = _ref.read(postCommentUseCaseProvider);
    final result = await postComment(serviceId: serviceId, text: text);
    result.when(
      onSuccess: (_) => state = const CommentFormState(status: CommentSubmitStatus.success),
      onFailure: (failure) => state = CommentFormState(status: CommentSubmitStatus.error, error: failure.message),
    );
  }

  Future<void> submitReply({required String serviceId, required String commentId, required String text}) async {
    state = const CommentFormState(status: CommentSubmitStatus.submitting);
    final postReply = _ref.read(postReplyUseCaseProvider);
    final result = await postReply(serviceId: serviceId, commentId: commentId, text: text);
    result.when(
      onSuccess: (_) => state = const CommentFormState(status: CommentSubmitStatus.success),
      onFailure: (failure) => state = CommentFormState(status: CommentSubmitStatus.error, error: failure.message),
    );
  }
}

final commentFormNotifierProvider = StateNotifierProvider.autoDispose<CommentFormNotifier, CommentFormState>(
  (ref) => CommentFormNotifier(ref),
);
