import 'package:dio/dio.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/chat/data/models/announcement_post_model.dart';
import 'package:pms_app/features/chat/data/models/chat_conversation_model.dart';
import 'package:pms_app/features/chat/data/models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatConversationModel>> getConversations();
  Future<List<AnnouncementPostModel>> getAnnouncementPosts(String conversationId);
  Future<List<ChatMessageModel>> getPostComments(String postId);
  Future<List<ChatMessageModel>> getMessages(String conversationId);
  Future<ChatMessageModel> sendMessage({required String threadId, required String text});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  static const List<Map<String, dynamic>> _mockConversationsJson = [
    {
      'id': 'c1',
      'title': 'Gerlug Announcement',
      'avatarInitials': 'GV',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': "Fathers day event will be organized at playground",
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'announcement',
      'subscriberCount': 68,
    },
    {
      'id': 'c2',
      'title': 'Gerlug Reports',
      'avatarInitials': 'GV',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': 'Financial Report - May, 2024',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'announcement',
      'subscriberCount': 68,
    },
    {
      'id': 'c3',
      'title': 'Gerlug Public',
      'avatarInitials': 'GV',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': 'Thank you',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'publicGroup',
      'subscriberCount': 68,
    },
    {
      'id': 'c4',
      'title': 'Khos Urguu',
      'avatarInitials': 'KU',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': 'Would you please send me those?',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': false,
      'type': 'publicGroup',
      'subscriberCount': 0,
    },
    {
      'id': 'c5',
      'title': 'Khunnu 2222 Announcement',
      'avatarInitials': 'KH',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': 'Happy Naadam Fest',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'announcement',
      'subscriberCount': 54,
    },
    {
      'id': 'c6',
      'title': 'Khunnu 2222 Reports',
      'avatarInitials': 'KH',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': 'Quarterly Report - April, 2024',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'announcement',
      'subscriberCount': 54,
    },
    {
      'id': 'c7',
      'title': 'Khunnu 2222 Public',
      'avatarInitials': 'KH',
      'avatarUrl': null,
      'lastMessageSender': null,
      'lastMessagePreview': 'Please share your opinion!',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'publicGroup',
      'subscriberCount': 54,
    },
    {
      'id': 'c8',
      'title': 'Khun property management',
      'avatarInitials': 'KP',
      'avatarUrl': null,
      'lastMessageSender': 'Dulmaa',
      'lastMessagePreview': 'Photo',
      'timeLabel': 'Yesterday',
      'isUnread': true,
      'isGroup': true,
      'type': 'publicGroup',
      'subscriberCount': 12,
    },
  ];

  static const String _postBody =
      'Should you require any additional information or have any further '
      'inquiries regarding this issue, please feel free to reach out to us '
      'at your earliest convenience.\n\nWe are available to provide any '
      'details you may need.';

  /// One announcement feed per conversationId — falls back to a generic
  /// 2-post feed for any conversationId not explicitly listed below.
  static final Map<String, List<Map<String, dynamic>>> _mockPostsByConversation = {
    'c1': [
      {
        'id': 'c1-p1',
        'authorName': 'Gerlug Vista',
        'authorSubtitle': '15th Khoroo, Khan Uul District, Ulaanbaatar, Mongolia',
        'authorInitials': 'GV',
        'body': _postBody,
        'imageUrl': 'https://picsum.photos/seed/announcement1/700/500',
        'likeCount': 5,
        'commentCount': 18,
      },
      {
        'id': 'c1-p2',
        'authorName': 'Gerlug Vista',
        'authorSubtitle': '15th Khoroo, Khan Uul District, Ulaanbaatar, Mongolia',
        'authorInitials': 'GV',
        'body': _postBody,
        'imageUrl': 'https://picsum.photos/seed/announcement2/700/500',
        'likeCount': 2,
        'commentCount': 4,
      },
    ],
  };

  static final List<Map<String, dynamic>> _defaultPostsJson = [
    {
      'id': 'default-p1',
      'authorName': 'Group Admin',
      'authorSubtitle': 'Announcement',
      'authorInitials': 'GA',
      'body': _postBody,
      'imageUrl': 'https://picsum.photos/seed/announcementdefault/700/500',
      'likeCount': 1,
      'commentCount': 0,
    },
  ];

  /// One comment thread per postId — falls back to an empty thread.
  static final Map<String, List<Map<String, dynamic>>> _mockCommentsByPost = {
    'c1-p1': [
      {
        'id': 'cm1',
        'senderName': 'Zobayar Tuvshuu',
        'senderInitials': 'ZT',
        'text': 'I would like to participate. Is there any special dressing code?',
        'timeLabel': '6/24',
        'isMine': false,
      },
      {
        'id': 'cm2',
        'senderName': 'Dorj Jargalsaikhan',
        'senderInitials': 'DJ',
        'text': 'When and where will this event happen. Can I bring our guest?',
        'timeLabel': '6/25',
        'isMine': false,
      },
      {
        'id': 'cm3',
        'senderName': 'You',
        'senderInitials': 'ME',
        'text': 'When and where will this event?',
        'timeLabel': '18:15',
        'isMine': true,
        'isRead': true,
      },
    ],
  };

  /// One live message thread per conversationId — falls back to an empty
  /// thread for any conversationId not explicitly listed below.
  static final Map<String, List<Map<String, dynamic>>> _mockMessagesByConversation = {
    'c3': [
      {
        'id': 'm1',
        'senderName': 'Zobayar Tuvshuu',
        'senderInitials': 'ZT',
        'text': 'I would like to participate. Is there any special dressing code?',
        'timeLabel': '6/21',
        'isMine': false,
      },
      {
        'id': 'm2',
        'senderName': 'Dorj Jargalsaikhan',
        'senderInitials': 'DJ',
        'text': 'When and where will this event happen. Can I bring our guest?',
        'timeLabel': '6/22',
        'isMine': false,
      },
      {
        'id': 'm3',
        'senderName': 'You',
        'senderInitials': 'ME',
        'text': 'When and where will this event?',
        'timeLabel': '18:15',
        'isMine': true,
        'isRead': true,
      },
      {
        'id': 'm4',
        'senderName': 'You',
        'senderInitials': 'ME',
        'text': 'How can I register in this event?',
        'timeLabel': '18:15',
        'isMine': true,
        'isRead': true,
      },
      {
        'id': 'm5',
        'senderName': 'You',
        'senderInitials': 'ME',
        'text': 'Is there anyone?',
        'timeLabel': '18:15',
        'isMine': true,
        'isRead': true,
      },
      {
        'id': 'm6',
        'senderName': 'Zobayar Tuvshuu',
        'senderInitials': 'ZT',
        'text': 'I would like to participate. Is there any special dressing code?',
        'timeLabel': '6/23',
        'isMine': false,
      },
      {
        'id': 'm7',
        'senderName': 'You',
        'senderInitials': 'ME',
        'text': 'When and where will this event?',
        'timeLabel': '18:15',
        'isMine': true,
        'isRead': true,
      },
      {
        'id': 'm8',
        'senderName': 'Zobayar Tuvshuu',
        'senderInitials': 'ZT',
        'text': 'I would like to participate. Is there any special dressing code?',
        'timeLabel': '6/24',
        'isMine': false,
      },
      {
        'id': 'm9',
        'senderName': 'Dorj Jargalsaikhan',
        'senderInitials': 'DJ',
        'text': 'When and where will this event happen. Can I bring our guest?',
        'timeLabel': '6/25',
        'isMine': false,
      },
      {
        'id': 'm10',
        'senderName': 'You',
        'senderInitials': 'ME',
        'text': 'When and where will this event?',
        'timeLabel': '18:15',
        'isMine': true,
        'isRead': true,
      },
    ],
  };

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 600));
      return _mockConversationsJson.map(ChatConversationModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(AppConstants.endpointChatConversations);
      // final data = response.data as List<dynamic>;
      // return data
      //     .map((json) => ChatConversationModel.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load conversations.');
    } catch (e) {
      throw ServerException('Unexpected error loading conversations: $e');
    }
  }

  @override
  Future<List<AnnouncementPostModel>> getAnnouncementPosts(String conversationId) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));
      final json = _mockPostsByConversation[conversationId] ?? _defaultPostsJson;
      return json.map(AnnouncementPostModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(
      //   AppConstants.endpointChatAnnouncementPosts,
      //   queryParameters: {'conversationId': conversationId},
      // );
      // final data = response.data as List<dynamic>;
      // return data
      //     .map((json) => AnnouncementPostModel.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load announcement posts.');
    } catch (e) {
      throw ServerException('Unexpected error loading announcement posts: $e');
    }
  }

  @override
  Future<List<ChatMessageModel>> getPostComments(String postId) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 450));
      final json = _mockCommentsByPost[postId] ?? const <Map<String, dynamic>>[];
      return json.map(ChatMessageModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(
      //   AppConstants.endpointChatPostComments,
      //   queryParameters: {'postId': postId},
      // );
      // final data = response.data as List<dynamic>;
      // return data
      //     .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load comments.');
    } catch (e) {
      throw ServerException('Unexpected error loading comments: $e');
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages(String conversationId) async {
    try {
      // ---- MOCK (no backend yet) ---------------------------------------
      await Future.delayed(const Duration(milliseconds: 500));
      final json = _mockMessagesByConversation[conversationId] ?? const <Map<String, dynamic>>[];
      return json.map(ChatMessageModel.fromJson).toList();

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.get(
      //   AppConstants.endpointChatMessages,
      //   queryParameters: {'conversationId': conversationId},
      // );
      // final data = response.data as List<dynamic>;
      // return data
      //     .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
      //     .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to load messages.');
    } catch (e) {
      throw ServerException('Unexpected error loading messages: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({required String threadId, required String text}) async {
    try {
      // ---- MOCK (no backend yet) — echoes back as "my" message ---------
      await Future.delayed(const Duration(milliseconds: 300));
      return ChatMessageModel(
        id: 'local-${DateTime.now().microsecondsSinceEpoch}',
        senderName: 'You',
        senderInitials: 'ME',
        text: text,
        timeLabel: 'Now',
        isMine: true,
        isRead: false,
      );

      // ---- REAL API (uncomment once the backend exists) ---------------
      // final response = await _dio.post(
      //   AppConstants.endpointChatSendMessage,
      //   data: {'threadId': threadId, 'text': text},
      // );
      // return ChatMessageModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to send message.');
    } catch (e) {
      throw ServerException('Unexpected error sending message: $e');
    }
  }
}
