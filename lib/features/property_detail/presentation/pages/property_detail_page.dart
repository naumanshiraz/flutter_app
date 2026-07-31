import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/property_detail/presentation/providers/property_detail_provider.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/action_buttons_row.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/invoice_sheet.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/property_access_config_sheet.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/report_sheet.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/property_hero_header.dart';
import 'package:pms_app/features/property_detail/presentation/widgets/services_masonry_grid.dart';

class PropertyDetailPage extends ConsumerWidget {
  final String propertyId;

  const PropertyDetailPage({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(propertyDetailNotifierProvider(propertyId));
    final notifier = ref.read(propertyDetailNotifierProvider(propertyId).notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildBody(context, state, notifier),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PropertyDetailState state,
    PropertyDetailNotifier notifier,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.propertyDetail == null) {
      return _ErrorState(message: state.error!, onRetry: notifier.refresh);
    }

    final detail = state.propertyDetail!;

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyHeroHeader(
              imageUrls: detail.heroImageUrls,
              onBackPressed: () => context.pop(),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail.name,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      Text(detail.address, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => PropertyAccessConfigSheet.show(context),
                  child: Icon(Icons.settings_outlined, size: 20.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            ActionButtonsRow(
              onReportPressed: () => ReportSheet.show(context),
              onInvoicePressed: () => InvoiceSheet.show(context),
            ),
            SizedBox(height: 18.h),
            Text.rich(
              TextSpan(
                text: 'Available',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
                children: [
                  TextSpan(text: '  services', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            if (state.services.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Center(
                  child: Text('No services available for this property yet.', style: AppTextStyles.bodySecondary),
                ),
              )
            else
              ServicesMasonryGrid(
                services: state.services,
                layout: detail.servicesLayout,
              ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 36.sp),
            SizedBox(height: 12.h),
            Text(message, textAlign: TextAlign.center, style: AppTextStyles.bodySecondary),
            SizedBox(height: 16.h),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
