import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/chat/data/models/announcement_post_model.dart';
import 'package:pms_app/features/chat/data/models/chat_conversation_model.dart';
import 'package:pms_app/features/chat/data/models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatConversationModel>> getConversations({required int limit, required int offset});
  Future<List<AnnouncementPostModel>> getAnnouncementPosts(String conversationId);
  Future<List<ChatMessageModel>> getPostComments({
    required String conversationId,
    required String postId,
  });
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage({required String threadId, required String text});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  static const int _messagesLimit = 50;

  /// LIVE: GET /api/app/conversations?limit=&offset=
  @override
  Future<List<ChatConversationModel>> getConversations({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointChatConversations,
        queryParameters: {'limit': limit, 'offset': offset},
      );
      final body = response.data;
      final rows = body is List
          ? body
          : (body is Map ? (body['items'] ?? body['data'] ?? body['results']) : null);
      if (rows is! List) {
        throw const ServerException('Unexpected conversations response.');
      }
      return rows
          .map((json) => ChatConversationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
      throw ServerException(serverMessage ?? e.message ?? 'Failed to load conversations.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error loading conversations: $e');
    }
  }

  /// LIVE: GET /api/app/conversations/{id}/messages?limit=50
  Future<List<Map<String, dynamic>>> _fetchRows(String path) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: {'limit': _messagesLimit},
      );
      final body = response.data;
      final rows = body is List
          ? body
          : (body is Map ? (body['items'] ?? body['data'] ?? body['results']) : null);
      if (rows is! List) {
        throw const ServerException('Unexpected response.');
      }
      return rows.cast<Map<String, dynamic>>();
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
      throw ServerException(serverMessage ?? e.message ?? 'Failed to load messages.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected error loading messages: $e');
    }
  }

  @override
  Future<List<AnnouncementPostModel>> getAnnouncementPosts(String conversationId) async {
    final rows = await _fetchRows(AppConstants.endpointChatMessages(conversationId));
    return rows.map(AnnouncementPostModel.fromJson).toList();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    final rows = await _fetchRows(AppConstants.endpointChatMessages(conversationId));
    return rows.map(ChatMessageModel.fromJson).toList();
  }

  /// LIVE: GET /api/app/conversations/{id}/posts/{postId}/comments?limit=50
  @override
  Future<List<ChatMessageModel>> getPostComments({
    required String conversationId,
    required String postId,
  }) async {
    final rows = await _fetchRows(AppConstants.endpointChatPostComments(conversationId, postId));
    return rows.map(ChatMessageModel.fromJson).toList();
  }

  @override
  Future<ChatMessageModel> sendMessage({required String threadId, required String text}) async {
    try {
      final response = await _dio.post(
        AppConstants.endpointChatMessages(threadId),
        data: {'content': text, 'parent_id': null},
      );
      final body = response.data;
      if (body is Map<String, dynamic> && body['id'] != null) {
        return ChatMessageModel.fromJson(body);
      }
      // Server returned no message body — show what was sent.
      return ChatMessageModel(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        groupId: threadId,
        senderName: 'You',
        content: text,
        sentAt: DateTime.now().toUtc().toIso8601String(),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map ? (data['message'] ?? data['detail'])?.toString() : null;
      throw ServerException(serverMessage ?? e.message ?? 'Failed to send message.');
    } catch (e) {
      throw ServerException('Unexpected error sending message: $e');
    }
  }
}
