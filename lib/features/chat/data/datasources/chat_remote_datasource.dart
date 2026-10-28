import 'package:dio/dio.dart';
import 'package:pms_app/core/constants/app_constants.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/chat/data/models/announcement_post_model.dart';
import 'package:pms_app/features/chat/data/models/chat_conversation_model.dart';
import 'package:pms_app/features/chat/data/models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatConversationModel>> getConversations({required int limit, required int offset});
  Future<List<AnnouncementPostModel>> getAnnouncementPosts(String conversationId);
  Future<List<ChatMessageModel>> getPostComments(String postId);
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage({required String threadId, required String text});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  static const int _messagesLimit = 50;

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

  static final Map<String, List<Map<String, dynamic>>> _mockCommentsByPost = {
    'c1-p1': [
      {
        'id': 'cm1',
        'sender_id': 'mock-1',
        'sender_name': 'Zobayar Tuvshuu',
        'content': 'I would like to participate. Is there any special dressing code?',
        'sent_at': '2026-06-24T10:00:00Z',
      },
      {
        'id': 'cm2',
        'sender_id': 'mock-2',
        'sender_name': 'Dorj Jargalsaikhan',
        'content': 'When and where will this event happen. Can I bring our guest?',
        'sent_at': '2026-06-25T10:00:00Z',
      },
    ],
  };

  Future<List<Map<String, dynamic>>> _fetchMessageRows(String conversationId) async {
    try {
      final response = await _dio.get(
        AppConstants.endpointChatMessages(conversationId),
        queryParameters: {'limit': _messagesLimit},
      );
      final body = response.data;
      final rows = body is List
          ? body
          : (body is Map ? (body['items'] ?? body['data'] ?? body['results']) : null);
      if (rows is! List) {
        throw const ServerException('Unexpected messages response.');
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
    final rows = await _fetchMessageRows(conversationId);
    return rows.map(AnnouncementPostModel.fromJson).toList();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    final rows = await _fetchMessageRows(conversationId);
    return rows.map(ChatMessageModel.fromJson).toList();
  }

  @override
  Future<List<ChatMessageModel>> getPostComments(String postId) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 450));
      final json = _mockCommentsByPost[postId] ?? const <Map<String, dynamic>>[];
      return json.map(ChatMessageModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(
      //   AppConstants.endpointChatPostComments,
      //   queryParameters: {'postId': postId},
      // );
      // final data = response.data as List<dynamic>;
      // return data
      //     .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load comments.');
    } catch (e) {
      throw ServerException('Unexpected error loading comments: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({required String threadId, required String text}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return ChatMessageModel(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        groupId: threadId,
        senderName: 'You',
        content: text,
        sentAt: DateTime.now().toUtc().toIso8601String(),
      );

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.post(
      //   AppConstants.endpointChatSendMessage,
      //   data: {'threadId': threadId, 'text': text},
      // );
      // return ChatMessageModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to send message.');
    } catch (e) {
      throw ServerException('Unexpected error sending message: $e');
    }
  }
}
