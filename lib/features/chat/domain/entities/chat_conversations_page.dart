import 'package:equatable/equatable.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';

/// One page of conversations plus whether the server may have more.
class ChatConversationsPage extends Equatable {
  final List<ChatConversation> items;
  final bool hasMore;

  const ChatConversationsPage({required this.items, required this.hasMore});

  @override
  List<Object?> get props => [items, hasMore];
}
