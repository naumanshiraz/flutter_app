import 'package:pms_app/core/utils/result.dart';

abstract class CommentRepository {
  Future<Result<void>> postComment({required String serviceId, required String text});

  Future<Result<void>> postReply({required String serviceId, required String commentId, required String text});
}
