import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class ChatComposer extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isSending;

  const ChatComposer({super.key, required this.onSend, this.isSending = false});

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.mic_none, size: 22.sp, color: AppColors.textBlack),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _controller,
              style: AppTextStyles.inputText,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: AppTextStyles.inputHint,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                suffixIcon: Icon(Icons.emoji_emotions_outlined, size: 20.sp, color: AppColors.textSecondary),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Icons.add_circle_outline, size: 22.sp, color: AppColors.textBlack),
          SizedBox(width: 8.w),
          InkWell(
            onTap: widget.isSending ? null : _submit,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: widget.isSending
                  ? SizedBox(
                      width: 20.sp,
                      height: 20.sp,
                      child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.textBlack),
                    )
                  : Icon(Icons.send_outlined, size: 22.sp, color: AppColors.textBlack),
            ),
          ),
        ],
      ),
    );
  }
}
