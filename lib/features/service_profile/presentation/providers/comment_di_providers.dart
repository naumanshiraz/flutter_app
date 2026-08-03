import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/di/injection.dart';
import 'package:pms_app/features/service_profile/data/datasources/comment_remote_datasource.dart';
import 'package:pms_app/features/service_profile/data/repositories/comment_repository_impl.dart';
import 'package:pms_app/features/service_profile/domain/repositories/comment_repository.dart';
import 'package:pms_app/features/service_profile/domain/usecases/comment_usecases.dart';

final commentRemoteDataSourceProvider = Provider<CommentRemoteDataSource>((ref) {
  return CommentRemoteDataSourceImpl(ref.watch(dioClientProvider).dio);
});

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepositoryImpl(remoteDataSource: ref.watch(commentRemoteDataSourceProvider));
});

final postCommentUseCaseProvider = Provider<PostCommentUseCase>((ref) {
  return PostCommentUseCase(ref.watch(commentRepositoryProvider));
});

final postReplyUseCaseProvider = Provider<PostReplyUseCase>((ref) {
  return PostReplyUseCase(ref.watch(commentRepositoryProvider));
});
