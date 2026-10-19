import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/confirm_dialog.dart';
import 'package:pms_app/features/join_requests/presentation/providers/join_requests_provider.dart';
import 'package:pms_app/features/join_requests/presentation/widgets/reason_dialog.dart';
import 'package:pms_app/features/join_requests/presentation/widgets/request_card.dart';

class JoinRequestsPage extends ConsumerWidget {
  const JoinRequestsPage({super.key});

  void _toast(BuildContext context, String? error) {
    if (error != null) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

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
          itemCount: state.items.length,
          itemBuilder: (context, i) {
            final item = state.items[i];
            return RequestCard(
              title: item.requesterName.isNotEmpty ? item.requesterName : item.identifier,
              details: [
                MapEntry('Contact', item.identifier),
                MapEntry('Relation', item.relation),
                MapEntry('Household', item.household),
                MapEntry('Status', item.status),
              ],
              primaryLabel: 'Approve',
              secondaryLabel: 'Reject',
              onPrimary: () async => _toast(context, await notifier.approve(item.id)),
              onSecondary: () async {
                final reason = await ReasonDialog.show(context);
                if (reason == null || !context.mounted) return;
                _toast(context, await notifier.reject(item.id, reason));
              },
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
