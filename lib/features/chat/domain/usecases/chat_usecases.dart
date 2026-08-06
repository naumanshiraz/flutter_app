import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_filter.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';
import 'package:pms_app/features/chat/domain/repositories/chat_repository.dart';

class GetChatConversationsUseCase {
  final ChatRepository _repository;
  const GetChatConversationsUseCase(this._repository);

  Future<Result<List<ChatConversation>>> call({ChatFilter filter = ChatFilter.all}) {
    return _repository.getConversations(filter: filter);
  }
}

class GetAnnouncementPostsUseCase {
  final ChatRepository _repository;
  const GetAnnouncementPostsUseCase(this._repository);

  Future<Result<List<AnnouncementPost>>> call(String conversationId) {
    return _repository.getAnnouncementPosts(conversationId);
  }
}

class GetPostCommentsUseCase {
  final ChatRepository _repository;
  const GetPostCommentsUseCase(this._repository);

  Future<Result<List<ChatMessage>>> call(String postId) {
    return _repository.getPostComments(postId);
  }
}

class GetMessagesUseCase {
  final ChatRepository _repository;
  const GetMessagesUseCase(this._repository);

  Future<Result<List<ChatMessage>>> call(String conversationId) {
    return _repository.getMessages(conversationId);
  }
}

class SendMessageUseCase {
  final ChatRepository _repository;
  const SendMessageUseCase(this._repository);

  Future<Result<ChatMessage>> call({required String threadId, required String text}) {
    return _repository.sendMessage(threadId: threadId, text: text);
  }
}
