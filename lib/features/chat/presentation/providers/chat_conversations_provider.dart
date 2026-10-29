import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/chat/domain/entities/chat_conversation.dart';
import 'package:pms_app/features/chat/domain/entities/chat_filter.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_di_providers.dart';

const int kChatConversationsPageSize = 50;

class ChatConversationsState {
  final List<ChatConversation> conversations;
  final ChatFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final String? loadMoreError;

  const ChatConversationsState({
    this.conversations = const [],
    this.filter = ChatFilter.all,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.loadMoreError,
  });

  List<ChatConversation> get visible {
    switch (filter) {
      case ChatFilter.unread:
        return conversations.where((c) => c.isUnread).toList();
      case ChatFilter.groups:
        return conversations.where((c) => c.isGroup).toList();
      case ChatFilter.all:
        return conversations;
    }
  }

  ChatConversationsState copyWith({
    List<ChatConversation>? conversations,
    ChatFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    String? loadMoreError,
    bool clearError = false,
    bool clearLoadMoreError = false,
  }) {
    return ChatConversationsState(
      conversations: conversations ?? this.conversations,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      loadMoreError: clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}

class ChatConversationsNotifier extends StateNotifier<ChatConversationsState> {
  final Ref _ref;
  int _epoch = 0;

  ChatConversationsNotifier(this._ref) : super(const ChatConversationsState()) {
    refresh();
  }

  Future<void> refresh() async {
    final epoch = ++_epoch;
    final hadData = state.conversations.isNotEmpty;
    state = state.copyWith(
      isLoading: !hadData,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );

    final result = await _ref.read(getChatConversationsUseCaseProvider)(
      limit: kChatConversationsPageSize,
      offset: 0,
    );
    if (!mounted || epoch != _epoch) return;

    result.when(
      onSuccess: (page) {
        state = state.copyWith(
          conversations: page.items,
          hasMore: page.hasMore,
          isLoading: false,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: hadData ? null : failure.message,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    final epoch = _epoch;
    state = state.copyWith(isLoadingMore: true, clearLoadMoreError: true);

    final result = await _ref.read(getChatConversationsUseCaseProvider)(
      limit: kChatConversationsPageSize,
      offset: state.conversations.length,
    );
    if (!mounted || epoch != _epoch) return;

    result.when(
      onSuccess: (page) {
        final known = state.conversations.map((c) => c.id).toSet();
        final fresh = page.items.where((c) => !known.contains(c.id)).toList();
        state = state.copyWith(
          conversations: [...state.conversations, ...fresh],
          hasMore: page.hasMore && page.items.isNotEmpty,
          isLoadingMore: false,
        );
      },
      onFailure: (failure) {
        state = state.copyWith(isLoadingMore: false, loadMoreError: failure.message);
      },
    );
  }

  Future<void> markRead(String conversationId) async {
    final target = state.conversations.where((c) => c.id == conversationId).firstOrNull;
    if (target == null || !target.isUnread) return;
    state = state.copyWith(
      conversations: [
        for (final c in state.conversations) c.id == conversationId ? c.copyWith(isUnread: false) : c,
      ],
    );
    final result = await _ref.read(markConversationReadUseCaseProvider)(conversationId);
    if (!mounted) return;
    result.when(
      onSuccess: (_) {},
      onFailure: (_) {
        state = state.copyWith(
          conversations: [
            for (final c in state.conversations) c.id == conversationId ? c.copyWith(isUnread: true) : c,
          ],
        );
      },
    );
  }

  void onFilterChanged(ChatFilter filter) {
    if (filter == state.filter) return;
    state = state.copyWith(filter: filter);
  }
}

final chatConversationsProvider =
    StateNotifierProvider.autoDispose<ChatConversationsNotifier, ChatConversationsState>(
  (ref) => ChatConversationsNotifier(ref),
);
