import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/chat/presentation/widgets/chat_attachment_sheet.dart';
import 'package:pms_app/features/chat/presentation/widgets/emoji_picker_sheet.dart';
import 'package:pms_app/core/utils/svg_icons.dart';

class ChatComposer extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isSending;

  const ChatComposer({super.key, required this.onSend, this.isSending = false});

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();

  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _recordTimer;

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _insertEmoji(String emoji) {
    final selection = _controller.selection;
    final text = _controller.text;
    final insertAt = selection.start >= 0 ? selection.start : text.length;
    final newText = text.replaceRange(insertAt, selection.end >= 0 ? selection.end : text.length, emoji);
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: insertAt + emoji.length),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => EmojiPickerSheet(onEmojiSelected: _insertEmoji),
    );
  }

  void _showAttachmentSheet() {
    ChatAttachmentSheet.show(
      context,
      onAttached: (label) => widget.onSend(label),
    );
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordSeconds++);
    });
  }

  void _stopRecording({required bool send}) {
    _recordTimer?.cancel();
    _recordTimer = null;
    final seconds = _recordSeconds;
    setState(() => _isRecording = false);
    if (send && seconds > 0) {
      widget.onSend('🎤 Voice message (${seconds}s)');
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
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
      child: _isRecording ? _buildRecordingRow() : _buildComposerRow(),
    );
  }

  Widget _buildRecordingRow() {
    return Row(
      children: [
        Icon(Icons.fiber_manual_record, size: 14.sp, color: AppColors.error),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            'Recording... ${_recordSeconds}s',
            style: AppTextStyles.body.copyWith(fontSize: 13.sp),
          ),
        ),
        TextButton(
          onPressed: () => _stopRecording(send: false),
          child: const Text('Cancel'),
        ),
        GestureDetector(
          onTap: () => _stopRecording(send: true),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: SvgIcons.plane(),
          ),
        ),
      ],
    );
  }

  Widget _buildComposerRow() {
    return Row(
      children: [
        GestureDetector(
          onLongPressStart: (_) => _startRecording(),
          onLongPressEnd: (_) => _stopRecording(send: true),
          onLongPressCancel: () => _stopRecording(send: false),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: SvgIcons.microphone()
          ),
        ),
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
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
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
              suffixIcon: InkWell(
                onTap: _showEmojiPicker,
                customBorder: const CircleBorder(),
                child: SvgIcons.emoji(size: 22, color: AppColors.textLightGrey),
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 30.w,
                minHeight: 32.h,
                maxHeight: 32.h,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: _showAttachmentSheet,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: SvgIcons.plus_rounded(),
          ),
        ),
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
                    child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF111928)),
                  )
                : SvgIcons.plane(),
          ),
        ),
      ],
    );
  }
}
