import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_filter.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<Result<List<ChatConversation>>> getConversations({
    ChatFilter filter = ChatFilter.all,
  });

  Future<Result<List<AnnouncementPost>>> getAnnouncementPosts(String conversationId);

  Future<Result<List<ChatMessage>>> getPostComments(String postId);

  Future<Result<List<ChatMessage>>> getMessages(String conversationId);

  Future<Result<ChatMessage>> sendMessage({required String threadId, required String text});
}
