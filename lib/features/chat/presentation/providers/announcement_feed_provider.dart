import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/features/chat/domain/entities/announcement_post.dart';
import 'package:pms_app/features/chat/presentation/providers/chat_di_providers.dart';

class AnnouncementFeedState {
  final List<AnnouncementPost> posts;
  final bool isLoading;
  final String? errorMessage;

  const AnnouncementFeedState({
    this.posts = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  AnnouncementFeedState copyWith({
    List<AnnouncementPost>? posts,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AnnouncementFeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AnnouncementFeedNotifier extends StateNotifier<AnnouncementFeedState> {
  final Ref _ref;
  final String conversationId;

  AnnouncementFeedNotifier(this._ref, this.conversationId)
      : super(const AnnouncementFeedState()) {
    _fetch();
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final useCase = _ref.read(getAnnouncementPostsUseCaseProvider);
    final result = await useCase(conversationId);
    result.when(
      onSuccess: (posts) => state = state.copyWith(posts: posts, isLoading: false),
      onFailure: (failure) =>
          state = state.copyWith(isLoading: false, errorMessage: failure.message),
    );
  }

  Future<void> refresh() => _fetch();
}

final announcementFeedProvider = StateNotifierProvider.autoDispose
    .family<AnnouncementFeedNotifier, AnnouncementFeedState, String>(
  (ref, conversationId) => AnnouncementFeedNotifier(ref, conversationId),
);
