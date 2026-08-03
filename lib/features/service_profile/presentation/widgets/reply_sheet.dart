import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/service_profile/presentation/providers/comment_form_provider.dart';

class ReplySheet extends ConsumerStatefulWidget {
  final String serviceId;
  final String commentId;
  final String authorName;

  const ReplySheet({super.key, required this.serviceId, required this.commentId, required this.authorName});

  static Future<void> show(BuildContext context, {required String serviceId, required String commentId, required String authorName}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.r))),
      builder: (context) => ReplySheet(serviceId: serviceId, commentId: commentId, authorName: authorName),
    );
  }

  @override
  ConsumerState<ReplySheet> createState() => _ReplySheetState();
}

class _ReplySheetState extends ConsumerState<ReplySheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(commentFormNotifierProvider, (previous, next) {
      if (next.status == CommentSubmitStatus.success) {
        Navigator.of(context).pop();
      } else if (next.status == CommentSubmitStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error ?? 'Failed to post reply.')));
      }
    });
    final isSubmitting = ref.watch(commentFormNotifierProvider).status == CommentSubmitStatus.submitting;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
            height: 48.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    'Reply to ${widget.authorName}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    iconSize: 28.sp,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
            SizedBox(height: 8.h),
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add a reply',
                hintStyle: AppTextStyles.caption,
                isDense: true,
                contentPadding: EdgeInsets.all(12.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Reduce radius here
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: isSubmitting ? null : _onPost,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
                child: isSubmitting
                    ? SizedBox(width: 16.w, height: 16.w, child: const CircularProgressIndicator(strokeWidth: 2))
                    : Text('Post', style: AppTextStyles.buttonSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPost() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(commentFormNotifierProvider.notifier).submitReply(
          serviceId: widget.serviceId,
          commentId: widget.commentId,
          text: text,
        );
  }
}
