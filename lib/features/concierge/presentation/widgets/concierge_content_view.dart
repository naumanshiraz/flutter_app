import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/concierge/presentation/providers/concierge_services_provider.dart';
import 'package:pms_app/features/concierge/presentation/widgets/concierge_category_tabs.dart';
import 'package:pms_app/features/concierge/presentation/widgets/concierge_services_grid.dart';
import 'package:pms_app/features/property_detail/domain/entities/service_listing.dart';

class ConciergeContentView extends ConsumerWidget {
  const ConciergeContentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conciergeServicesProvider);
    final notifier = ref.read(conciergeServicesProvider.notifier);

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
            sliver: SliverToBoxAdapter(
              child: ConciergeCategoryTabs(
                selected: state.category,
                onChanged: notifier.onCategoryChanged,
              ),
            ),
          ),
          if (state.isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else if (state.errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 32.sp, color: AppColors.error),
                      SizedBox(height: 10.h),
                      Text(state.errorMessage!, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
                      SizedBox(height: 12.h),
                      TextButton(onPressed: notifier.refresh, child: const Text('Try again')),
                    ],
                  ),
                ),
              ),
            )
          else if (state.items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No services found.', style: AppTextStyles.bodySecondary)),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              sliver: SliverToBoxAdapter(
                child: ConciergeServicesGrid(
                  items: state.items,
                  layout: state.layout,
                  onServiceTap: (service) => _openServiceProfile(context, service),
                  onServiceMorePressed: (service) => _openServiceProfile(context, service),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openServiceProfile(BuildContext context, ServiceListing service) {
    context.push(RouteNames.serviceProfile, extra: service.id);
  }
}
