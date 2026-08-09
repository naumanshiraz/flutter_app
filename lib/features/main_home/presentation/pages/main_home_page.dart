import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/widgets/bottom_nav_bar.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_conversations_view.dart';
import 'package:pms_app/features/concierge/presentation/pages/concierge_page.dart';
import 'package:pms_app/features/home/presentation/widgets/home_content.dart';
import 'package:pms_app/features/main_home/presentation/widgets/main_home_content_view.dart';

/// The Main Home screen — also the shared bottom-nav shell used by every
/// screen with a bottom nav. All four tabs are rendered inline (no
/// cross-route navigation), so tapping Home/Chat/Cart/Community is always
/// a plain, instant local tab switch:
///  0 Home      -> [MainHomeContentView]
///  1 Chat      -> [ChatConversationsView]
///  2 Cart      -> placeholder (not built yet)
///  3 Community -> [HomeContent] (Home Screen; Community isn't built yet)
class MainHomePage extends ConsumerStatefulWidget {
  final String? propertyId;

  const MainHomePage({super.key, this.propertyId});

  @override
  ConsumerState<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends ConsumerState<MainHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    MainHomeContentView(),
    ChatConversationsView(),
    ConciergePage(),
    HomeContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _selectedIndex, children: _tabs),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
