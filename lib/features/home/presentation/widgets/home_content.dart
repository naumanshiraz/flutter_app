import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/menu_sheet.dart';
import 'package:pms_app/core/widgets/settings_sheet.dart';
import 'package:pms_app/features/home/presentation/providers/profile_summary_provider.dart';
import 'package:pms_app/features/home/presentation/providers/property_listings_provider.dart';
import 'package:pms_app/features/home/presentation/widgets/profile_header.dart';
import 'package:pms_app/features/home/presentation/widgets/property_card.dart';
import 'package:pms_app/features/home/presentation/widgets/search_add_bar.dart';
import 'package:pms_app/core/utils/svg_icons.dart';

class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileSummaryProvider);
    final listingsState = ref.watch(propertyListingsProvider);
    final listingsNotifier = ref.read(propertyListingsProvider.notifier);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(profileSummaryProvider);
        await listingsNotifier.refresh();
      },
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
            sliver: SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => SettingsSheet.show(context),
                      icon: SvgIcons.gear(),
                    ),
                    IconButton(
                      onPressed: () => MenuSheet.show(context),
                      icon: SvgIcons.menu(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
            sliver: SliverToBoxAdapter(
              child: profileAsync.when(
                data: (profile) => ProfileHeader(
                  profile: profile,
                  onEditProfile: () async {
                    await context.push(RouteNames.editProfile);
                    ref.invalidate(profileSummaryProvider);
                  },
                ),
                loading: () => SizedBox(
                  height: 220.h,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
                error: (error, stackTrace) => SizedBox(
                  height: 120.h,
                  child: Center(
                    child: Text('Failed to load profile.', style: AppTextStyles.bodySecondary),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
            sliver: SliverToBoxAdapter(
              child: SearchAddBar(
                onSearchChanged: listingsNotifier.onSearchChanged,
                onAddTap: () => context.push(RouteNames.properties),
              ),
            ),
          ),
          if (listingsState.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            )
          else if (listingsState.errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(listingsState.errorMessage!, style: AppTextStyles.bodySecondary),
              ),
            )
          else if (listingsState.listings.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('No properties found.', style: AppTextStyles.bodySecondary),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18.w,
                  mainAxisSpacing: 20.h,
                  childAspectRatio: 1.08,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PropertyCard(
                    listing: listingsState.listings[index],
                    onTap: () => context.push(RouteNames.mainHome, extra: listingsState.listings[index].id),
                  ),
                  childCount: listingsState.listings.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
