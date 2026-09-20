import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/svg_icons.dart';
import 'package:pms_app/core/widgets/menu_sheet.dart';
import 'package:pms_app/core/widgets/settings_sheet.dart';
import 'package:pms_app/features/home/domain/entities/profile_summary.dart';
import 'package:pms_app/features/home/presentation/providers/profile_summary_provider.dart';
import 'package:pms_app/features/home/presentation/widgets/profile_header.dart';
import 'package:pms_app/features/home/presentation/widgets/property_card.dart';
import 'package:pms_app/features/home/presentation/widgets/search_add_bar.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  String _query = '';

  List<Campus> _filter(List<Campus> campuses) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return campuses;
    return campuses.where((c) => c.name.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileSummaryProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(profileSummaryProvider),
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
                onSearchChanged: (value) => setState(() => _query = value),
                onAddTap: () => context.push(RouteNames.properties),
              ),
            ),
          ),
          profileAsync.when(
            data: (profile) {
              final campuses = _filter(profile.campuses);
              if (campuses.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      profile.campuses.isEmpty ? 'No properties found.' : 'No matches found.',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ),
                );
              }
              return SliverPadding(
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
                      campus: campuses[index],
                      onTap: () => context.push(RouteNames.mainHome, extra: campuses[index].id),
                    ),
                    childCount: campuses.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ),
            error: (error, stackTrace) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Failed to load properties.', style: AppTextStyles.bodySecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
