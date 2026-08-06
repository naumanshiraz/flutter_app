import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/chat/domain/entities/chat_message.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_di_providers.dart';

typedef ChatThreadKey = ({String threadId, bool isPostComments});

class ChatThreadState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isSending;
  final String? errorMessage;

  const ChatThreadState({
    this.messages = const [],
    this.isLoading = true,
    this.isSending = false,
    this.errorMessage,
  });

  ChatThreadState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatThreadState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ChatThreadNotifier extends StateNotifier<ChatThreadState> {
  final Ref _ref;
  final ChatThreadKey key;

  ChatThreadNotifier(this._ref, this.key) : super(const ChatThreadState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = key.isPostComments
        ? await _ref.read(getPostCommentsUseCaseProvider)(key.threadId)
        : await _ref.read(getMessagesUseCaseProvider)(key.threadId);
    result.when(
      onSuccess: (messages) => state = state.copyWith(messages: messages, isLoading: false),
      onFailure: (failure) =>
          state = state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    state = state.copyWith(isSending: true, clearError: true);
    final useCase = _ref.read(sendMessageUseCaseProvider);
    final result = await useCase(threadId: key.threadId, text: trimmed);
    result.when(
      onSuccess: (message) {
        state = state.copyWith(messages: [...state.messages, message], isSending: false);
      },
      onFailure: (failure) {
        state = state.copyWith(isSending: false, errorMessage: failure.message);
      },
    );
  }

  Future<void> refresh() => _fetch();
}

final chatThreadProvider =
    StateNotifierProvider.autoDispose.family<ChatThreadNotifier, ChatThreadState, ChatThreadKey>(
  (ref, key) => ChatThreadNotifier(ref, key),
);
