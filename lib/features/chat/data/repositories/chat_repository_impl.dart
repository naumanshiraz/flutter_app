import 'dart:convert';

import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/services/secure_storage_service.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:pms_app/features/chat/data/models/announcement_post_model.dart';
import 'package:pms_app/features/chat/data/models/chat_message_model.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversations_page.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';
import 'package:pms_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  ChatRepositoryImpl({
    required ChatRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  List<ChatMessageModel> _sortBySentAt(List<ChatMessageModel> models) {
    return [...models]..sort((a, b) {
        final ad = a.sentAtDate, bd = b.sentAtDate;
        if (ad == null || bd == null) return 0;
        return ad.compareTo(bd);
      });
  }

  Future<String?> _currentUserId() async {
    try {
      final token = await _secureStorage.getAuthToken();
      final parts = token?.split('.');
      if (parts == null || parts.length < 2) return null;
      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      if (payload is! Map) return null;
      return (payload['sub'] ?? payload['user_id'] ?? payload['uid'])?.toString();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result<ChatConversationsPage>> getConversations({
    required int limit,
    required int offset,
  }) async {
    try {
      final models = await _remoteDataSource.getConversations(limit: limit, offset: offset);
      return Success(
        ChatConversationsPage(
          items: models.map((m) => m.toEntity()).toList(),
          hasMore: models.length >= limit,
        ),
      );
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load conversations: $e'));
    }
  }

  @override
  Future<Result<List<AnnouncementPost>>> getAnnouncementPosts(String conversationId) async {
    try {
      final models = await _remoteDataSource.getAnnouncementPosts(conversationId);
      final sorted = [...models]..sort((a, b) {
          final ad = a.sentAtDate, bd = b.sentAtDate;
          if (ad == null || bd == null) return 0;
          return bd.compareTo(ad);
        });
      return Success(sorted.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load announcement posts: $e'));
    }
  }

  @override
  Future<Result<List<ChatMessage>>> getPostComments({
    required String conversationId,
    required String postId,
  }) async {
    try {
      final models = await _remoteDataSource.getPostComments(
        conversationId: conversationId,
        postId: postId,
      );
      final myId = await _currentUserId();
      return Success(
        _sortBySentAt(models).map((m) => m.toEntity(isMine: myId != null && m.senderId == myId)).toList(),
      );
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load comments: $e'));
    }
  }

  @override
  Future<Result<List<ChatMessage>>> getMessages(String conversationId) async {
    try {
      final models = await _remoteDataSource.getMessages(conversationId);
      final myId = await _currentUserId();
      final sorted = _sortBySentAt(models);
      return Success(
        sorted.map((m) => m.toEntity(isMine: myId != null && m.senderId == myId)).toList(),
      );
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load messages: $e'));
    }
  }

  @override
  Future<Result<ChatMessage>> sendMessage({required String threadId, required String text}) async {
    try {
      final model = await _remoteDataSource.sendMessage(threadId: threadId, text: text);
      return Success(model.toEntity(isMine: true));
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to send message: $e'));
    }
  }
}
