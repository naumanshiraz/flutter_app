import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/bottom_nav_bar.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/chat/presentation/pages/chat_list_page.dart';
import 'package:pms_app/features/concierge/presentation/pages/concierge_page.dart';

class GroupInfoArgs {
  final String conversationId;
  final String title;
  final String avatarInitials;
  final int subscriberCount;
  final bool isGroup;

  const GroupInfoArgs({
    required this.conversationId,
    required this.title,
    required this.avatarInitials,
    this.subscriberCount = 0,
    this.isGroup = true,
  });
}

class GroupInfoPage extends StatefulWidget {
  final GroupInfoArgs args;

  const GroupInfoPage({super.key, required this.args});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  int _selectedIndex = 0;
  bool _muteNotifications = false;

  String getInitials(String title) {
    final words = title.trim().split(RegExp(r'\s+'));

    if (words.isEmpty || words.first.isEmpty) return '';

    if (words.length == 1) {
      return words.first.substring(0, 1).toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildInfoTab(context),
            const ChatListPage(),
            const ConciergePage(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomNavBar(
          selectedIndex: _selectedIndex,
          onTap: (index) {
            if (index == 0) {
              context.go(RouteNames.mainHome);
            } else if (index == 3) {
              context.go(RouteNames.home);
            } else {
              setState(() => _selectedIndex = index);
            }
          }
        ),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.close, size: 22.sp, color: AppColors.textPrimary),
              ),
              Text('Group info', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.check, size: 22.sp, color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              SizedBox(height: 12.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 88.w,
                      height: 88.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary),
                      alignment: Alignment.center,
                      child: Text(
                        getInitials(widget.args.title),
                        style: AppTextStyles.appTitle.copyWith(fontSize: 26.sp, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      widget.args.title,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.args.isGroup
                          ? 'Group · ${widget.args.subscriberCount} subscribers'
                          : 'Direct message',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                height: 46.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text('Edit', style: AppTextStyles.buttonPrimary),
                ),
              ),
              SizedBox(height: 20.h),
              _infoRow(label: 'Media, links, and docs', onTap: () {}),
              const Divider(height: 1, color: AppColors.border),
              _switchRow(
                label: 'Mute notifications',
                value: _muteNotifications,
                onChanged: (value) => setState(() => _muteNotifications = value),
              ),
              const Divider(height: 1, color: AppColors.border),
              _infoRow(label: 'Wallpaper', onTap: () {}),
              const Divider(height: 1, color: AppColors.border),
              _infoRow(label: 'Starred messages', onTap: () {}),
              const Divider(height: 1, color: AppColors.border),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoRow({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
            Icon(Icons.chevron_right, size: 20.sp, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _switchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
          Transform.scale(
            scale: 0.65,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: AppColors.primary,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFF6B7280),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),  
        ],
      ),
    );
  }
}
