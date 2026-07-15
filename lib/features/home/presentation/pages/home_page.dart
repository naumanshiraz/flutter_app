import 'package:flutter/material.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/widgets/bottom_nav_bar.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/home/presentation/widgets/home_content.dart';

/// Owns the 4-tab bottom navigation shell. Only the Home tab has a real
/// module behind it today; Chat/Cart/Community render a shared
/// [PlaceholderPage] until those modules are built — swap each entry in
/// `_tabs` for its real page then, nothing else here needs to change.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    HomeContent(),
    PlaceholderPage(title: 'Chat', routeName: '/home (tab: chat)'),
    PlaceholderPage(title: 'Cart', routeName: '/home (tab: cart)'),
    PlaceholderPage(title: 'Community', routeName: '/home (tab: community)'),
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
