import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';

class EmojiPickerSheet extends StatelessWidget {
  final ValueChanged<String> onEmojiSelected;

  const EmojiPickerSheet({super.key, required this.onEmojiSelected});

  static const List<String> _commonEmojis = [
    '😀', '😂', '😍', '😊', '😉', '😢', '😭', '😡',
    '😮', '😴', '🥳', '😎', '🤔', '🙏', '👍', '👎',
    '👏', '🙌', '💪', '🤝', '❤️', '🔥', '🎉', '✨',
    '✅', '❌', '⭐', '💯', '😅', '🥰', '😘', '🤗',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _commonEmojis.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 4.h,
                crossAxisSpacing: 4.w,
              ),
              itemBuilder: (context, index) {
                final emoji = _commonEmojis[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(8.r),
                  onTap: () {
                    onEmojiSelected(emoji);
                    Navigator.of(context).pop();
                  },
                  child: Center(child: Text(emoji, style: TextStyle(fontSize: 24.sp))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
