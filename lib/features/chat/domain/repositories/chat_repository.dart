import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversations_page.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<Result<ChatConversationsPage>> getConversations({
    required int limit,
    required int offset,
  });

  Future<Result<List<AnnouncementPost>>> getAnnouncementPosts(String conversationId);

  Future<Result<List<ChatMessage>>> getPostComments({
    required String conversationId,
    required String postId,
  });

  Future<Result<List<ChatMessage>>> getMessages(String conversationId);

  Future<Result<ChatMessage>> sendMessage({
    required String threadId,
    required String text,
    String? parentId,
  });
}
