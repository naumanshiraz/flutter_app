import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/widgets/bottom_nav_bar.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/chat/presentation/pages/chat_list_page.dart';
import 'package:pms_app/features/home/presentation/widgets/home_content.dart';
import 'package:pms_app/features/main_home/presentation/widgets/main_home_content_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    HomeContent(),
    ChatListPage(),
    PlaceholderPage(title: 'Cart', routeName: '/home (tab: cart)'),
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
          onTap: (index) {
            if (index == 0) {
              context.go(RouteNames.mainHome);
            } else if (index == 3) {
              setState(() => _selectedIndex = 0);
            } else {
              setState(() => _selectedIndex = index);
            }
          },
        ),
      ),
    );
  }
}
