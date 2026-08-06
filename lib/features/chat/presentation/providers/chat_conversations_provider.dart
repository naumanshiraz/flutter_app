import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_filter.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_di_providers.dart';

class ChatConversationsState {
  final List<ChatConversation> conversations;
  final ChatFilter filter;
  final bool isLoading;
  final String? errorMessage;

  const ChatConversationsState({
    this.conversations = const [],
    this.filter = ChatFilter.all,
    this.isLoading = true,
    this.errorMessage,
  });

  ChatConversationsState copyWith({
    List<ChatConversation>? conversations,
    ChatFilter? filter,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatConversationsState(
      conversations: conversations ?? this.conversations,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ChatConversationsNotifier extends StateNotifier<ChatConversationsState> {
  final Ref _ref;

  ChatConversationsNotifier(this._ref) : super(const ChatConversationsState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = _ref.read(getChatConversationsUseCaseProvider);
    final result = await useCase(filter: state.filter);
    result.when(
      onSuccess: (conversations) {
        state = state.copyWith(conversations: conversations, isLoading: false);
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, errorMessage: failure.message);
      },
    );
  }

  void onFilterChanged(ChatFilter filter) {
    if (filter == state.filter) return;
    state = state.copyWith(filter: filter);
    _fetch();
  }

  Future<void> refresh() => _fetch();
}

final chatConversationsProvider =
    StateNotifierProvider.autoDispose<ChatConversationsNotifier, ChatConversationsState>(
  (ref) => ChatConversationsNotifier(ref),
);
