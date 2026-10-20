import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/join_requests/presentation/providers/join_requests_provider.dart';
import 'package:pms_app/features/join_requests/presentation/widgets/join_request_card.dart';

class JoinRequestsPage extends ConsumerWidget {
  const JoinRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(joinRequestsProvider);
    final notifier = ref.read(joinRequestsProvider.notifier);

    Widget body;
    if (state.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
            TextButton(onPressed: notifier.refresh, child: const Text('Retry')),
          ],
        ),
      );
    } else if (state.items.isEmpty) {
      body = Center(child: Text('No join requests.', style: AppTextStyles.bodySecondary));
    } else {
      body = RefreshIndicator(
        onRefresh: notifier.refresh,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          itemCount: state.items.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Text('Please review the join requests', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
              );
            }
            final request = state.items[i - 1];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.push(RouteNames.joinRequestReview, extra: request),
                child: JoinRequestCard(request: request, index: i - 1, total: state.items.length),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text('Join requests', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
      ),
      body: SafeArea(child: body),
    );
  }
}
