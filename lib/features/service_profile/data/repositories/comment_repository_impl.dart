import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/service_profile/data/datasources/comment_remote_datasource.dart';
import 'package:pms_app/features/service_profile/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;
  CommentRepositoryImpl({required CommentRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<void>> postComment({required String serviceId, required String text}) async {
    try {
      await _remoteDataSource.postComment(serviceId: serviceId, text: text);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to post comment: $e'));
    }
  }

  @override
  Future<Result<void>> postReply({required String serviceId, required String commentId, required String text}) async {
    try {
      await _remoteDataSource.postReply(serviceId: serviceId, commentId: commentId, text: text);
      return const Success(null);
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to post reply: $e'));
    }
  }
}
