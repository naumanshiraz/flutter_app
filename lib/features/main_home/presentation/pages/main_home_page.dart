import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/main_home/presentation/providers/main_home_provider.dart';
import 'package:pms_app/features/main_home/presentation/widgets/control_card.dart';
import 'package:pms_app/features/main_home/presentation/widgets/image_carousel.dart';
import 'package:pms_app/core/widgets/bottom_nav_bar.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/main_home/presentation/widgets/visitor_vehicle_signup_card.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/widgets/menu_sheet.dart';
import 'package:pms_app/features/activity_log/presentation/pages/activity_log_page.dart';

class MainHomePage extends ConsumerStatefulWidget {
  final String? propertyId;

  const MainHomePage({Key? key, this.propertyId}) : super(key: key);

  @override
  ConsumerState<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends ConsumerState<MainHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainHomeNotifierProvider);
    final notifier = ref.read(mainHomeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text('Good morning!', style: AppTextStyles.pageTitle),
        actions: [
          IconButton(
              onPressed: () => ActivityLogSheet.show(context),
              icon: const Icon(Icons.notifications_none)),
          IconButton(onPressed: () => MenuSheet.show(context), icon: const Icon(Icons.menu)),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildMainHomeTab(state, notifier),
          const PlaceholderPage(title: 'Chat', routeName: '/main-home (tab: chat)'),
          const PlaceholderPage(title: 'Cart', routeName: '/main-home (tab: cart)'),
          const PlaceholderPage(title: 'Community', routeName: '/main-home (tab: community)'),
        ],
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

  Widget _buildMainHomeTab(MainHomeState state, MainHomeNotifier notifier) {
    return state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: notifier.refresh,
              color: AppColors.primary,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _sectionChip('Main entrance', selected: false),
                          _sectionChip('Campus gates', selected: true),
                          _sectionChip('Elevator', selected: false),
                          _sectionChip('Vehicle', selected: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Use AppTextStyles.body (exists) instead of a non-existent `title`
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gerlug vista',
                                  style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w700, fontSize: 16.sp)),
                              Text(
                                '15th Khoroo, Khan Uul District, Ulaanbaatar, Mongolia 13146',
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          // Opens the full Property Detail screen (hero
                          // image, Report/Invoice, Available services).
                          onPressed: () => context.push(
                            RouteNames.propertyDetail,
                            extra: 'gerlug-vista',
                          ),
                          icon: const Icon(Icons.settings_outlined),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    ImageCarousel(imageUrls: [
                      'https://picsum.photos/800/400?image=10',
                      'https://picsum.photos/800/400?image=20',
                      'https://picsum.photos/800/400?image=30',
                    ]),

                    SizedBox(height: 18.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Available',
                            style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontSize: 16.sp),
                            children: [
                              TextSpan(
                                  text: '  controls',
                                  style: AppTextStyles.body
                                      .copyWith(fontWeight: FontWeight.w400)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    if (state.error != null) ...[
                      Text(
                        state.error!,
                        style: AppTextStyles.caption.copyWith(color: AppColors.error),
                      ),
                      SizedBox(height: 8.h),
                    ],

                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.controls.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5.w,
                        mainAxisSpacing: 5.h,
                        mainAxisExtent: 138.h,
                      ),
                      itemBuilder: (context, index) {
                        final c = state.controls[index];
                        return ControlCard(
                            control: c, onToggle: () => notifier.toggle(c.id));
                      },
                    ),

                    SizedBox(height: 20.h),

                    const VisitorVehicleSignupCard(),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
  }

  Widget _sectionChip(String label, {bool selected = false}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.textBlack : AppColors.border,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary)),
    );
  }
}
