import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/core/error/failures.dart';
import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_filter.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';
import 'package:pms_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<ChatConversation>>> getConversations({
    ChatFilter filter = ChatFilter.all,
  }) async {
    try {
      final models = await _remoteDataSource.getConversations();
      var conversations = models.map((m) => m.toEntity()).toList();

      switch (filter) {
        case ChatFilter.unread:
          conversations = conversations.where((c) => c.isUnread).toList();
          break;
        case ChatFilter.groups:
          conversations = conversations.where((c) => c.isGroup).toList();
          break;
        case ChatFilter.all:
          break;
      }

      return Success(conversations);
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
      return Success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to load announcement posts: $e'));
    }
  }

  @override
  Future<Result<List<ChatMessage>>> getPostComments(String postId) async {
    try {
      final models = await _remoteDataSource.getPostComments(postId);
      return Success(models.map((m) => m.toEntity()).toList());
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
      return Success(models.map((m) => m.toEntity()).toList());
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
      return Success(model.toEntity());
    } on ServerException catch (e) {
      return ResultError(ServerFailure(e.message));
    } catch (e) {
      return ResultError(UnknownFailure('Failed to send message: $e'));
    }
  }
}
