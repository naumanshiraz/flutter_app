import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/widgets/menu_sheet.dart';
import 'package:pms_app/features/activity_log/presentation/pages/activity_log_page.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_conversations_view.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_header.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: ChatHeader(
                // Bell opens the app-wide activity/notification log.
                onNotificationsTap: () => ActivityLogSheet.show(context),
                // Hamburger opens the shared settings/menu sheet.
                onMenuTap: () => MenuSheet.show(context),
              ),
            ),
            const Expanded(child: ChatConversationsView()),
          ],
        ),
      ),
    );
  }
}
