import 'package:equatable/equatable.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';

class ChatConversationsPage extends Equatable {
  final List<ChatConversation> items;
  final bool hasMore;

  const ChatConversationsPage({required this.items, required this.hasMore});

  @override
  List<Object?> get props => [items, hasMore];
}
