import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';

abstract class CommentRemoteDataSource {
  Future<void> postComment({required String serviceId, required String text});
  Future<void> postReply({required String serviceId, required String commentId, required String text});
}

class CommentRemoteDataSourceImpl implements CommentRemoteDataSource {
  final Dio _dio;
  CommentRemoteDataSourceImpl(this._dio);

  @override
  Future<void> postComment({required String serviceId, required String text}) async {
    try {
      // MOCK: no backend yet.
      await Future.delayed(const Duration(milliseconds: 400));
      return;

      // REAL API (uncomment once available)
      // await _dio.post('/services/$serviceId/comments', data: {'text': text});
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to post comment.');
    } catch (e) {
      throw ServerException('Unexpected error posting comment: $e');
    }
  }

  @override
  Future<void> postReply({required String serviceId, required String commentId, required String text}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return;

      // REAL API (uncomment once available)
      // await _dio.post('/services/$serviceId/comments/$commentId/replies', data: {'text': text});
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to post reply.');
    } catch (e) {
      throw ServerException('Unexpected error posting reply: $e');
    }
  }
}
