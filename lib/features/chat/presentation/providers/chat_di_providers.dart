import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:pms_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:pms_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:pms_app/features/chat/domain/usecases/chat_usecases.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(remoteDataSource: ref.watch(chatRemoteDataSourceProvider));
});

final getChatConversationsUseCaseProvider = Provider<GetChatConversationsUseCase>((ref) {
  return GetChatConversationsUseCase(ref.watch(chatRepositoryProvider));
});

final getAnnouncementPostsUseCaseProvider = Provider<GetAnnouncementPostsUseCase>((ref) {
  return GetAnnouncementPostsUseCase(ref.watch(chatRepositoryProvider));
});

final getPostCommentsUseCaseProvider = Provider<GetPostCommentsUseCase>((ref) {
  return GetPostCommentsUseCase(ref.watch(chatRepositoryProvider));
});

final getMessagesUseCaseProvider = Provider<GetMessagesUseCase>((ref) {
  return GetMessagesUseCase(ref.watch(chatRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(chatRepositoryProvider));
});
