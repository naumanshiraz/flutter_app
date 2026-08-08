import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

enum ChatAttachmentType { document, audio, photo, camera }

class ChatAttachmentSheet extends StatelessWidget {
  final ValueChanged<String> onAttached;

  const ChatAttachmentSheet({super.key, required this.onAttached});

  static Future<void> show(BuildContext context, {required ValueChanged<String> onAttached}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => ChatAttachmentSheet(onAttached: onAttached),
    );
  }

  Future<void> _handleTap(BuildContext context, ChatAttachmentType type) async {
    switch (type) {
      case ChatAttachmentType.photo:
      case ChatAttachmentType.camera:
        final picker = ImagePicker();
        final XFile? file = await picker.pickImage(
          source: type == ChatAttachmentType.camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 85,
        );
        if (file == null) return;
        onAttached('📷 Photo: ${file.name}');
        break;
      case ChatAttachmentType.document:
        // No file_picker package wired up yet — placeholder until it is.
        onAttached('📎 Document attached');
        break;
      case ChatAttachmentType.audio:
        // No audio-file picker package wired up yet — placeholder until it is.
        onAttached('🎵 Audio file attached');
        break;
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      (ChatAttachmentType.document, Icons.insert_drive_file_outlined, 'Document'),
      (ChatAttachmentType.audio, Icons.audiotrack_outlined, 'Audio'),
      (ChatAttachmentType.photo, Icons.image_outlined, 'Photo'),
      (ChatAttachmentType.camera, Icons.camera_alt_outlined, 'Camera'),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: options.map((option) {
                final (type, icon, label) = option;
                return InkWell(
                  onTap: () => _handleTap(context, type),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
                    child: Column(
                      children: [
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary),
                          child: Icon(icon, size: 24.sp, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 8.h),
                        Text(label, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
