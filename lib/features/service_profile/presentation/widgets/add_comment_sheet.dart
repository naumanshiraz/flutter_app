import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/utils/svg_icons.dart';
import 'package:pms_app/features/service_profile/presentation/providers/comment_form_provider.dart';

class AddCommentSheet extends ConsumerStatefulWidget {
  final String serviceId;

  const AddCommentSheet({super.key, required this.serviceId});

  static Future<void> show(BuildContext context, {required String serviceId}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => AddCommentSheet(serviceId: serviceId),
    );
  }

  @override
  ConsumerState<AddCommentSheet> createState() => _AddCommentSheetState();
}

class _AddCommentSheetState extends ConsumerState<AddCommentSheet> {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error ?? 'Failed to post comment.')));
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
                      'Add Comment',
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
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                    'Share what you like about this, how it inspired you, or simply give a compliment',
                hintStyle: AppTextStyles.caption,
                isDense: true,
                contentPadding: EdgeInsets.all(12.w),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgIcons.link(size: 19, color: AppColors.textDarkGrey),
                SizedBox(width: 8.w),
                const Spacer(),
                OutlinedButton(
                  onPressed: isSubmitting ? null : _onPost,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 5.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isSubmitting
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Post',
                          style: AppTextStyles.buttonSecondary,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onPost() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(commentFormNotifierProvider.notifier).submitComment(serviceId: widget.serviceId, text: text);
  }
}
