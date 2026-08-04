import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class OtpInputBoxes extends StatefulWidget {
  static const int length = 6;

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;

  const OtpInputBoxes({super.key, required this.onChanged, this.onCompleted});

  @override
  State<OtpInputBoxes> createState() => _OtpInputBoxesState();
}

class _OtpInputBoxesState extends State<OtpInputBoxes> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(OtpInputBoxes.length, (_) => TextEditingController());
    _focusNodes = List.generate(OtpInputBoxes.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _handleChange(int index, String value) {
    if (value.isNotEmpty && index < OtpInputBoxes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    widget.onChanged(_code);
    if (_code.length == OtpInputBoxes.length) {
      widget.onCompleted?.call(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(OtpInputBoxes.length, (index) {
        final bool isFilled = _controllers[index].text.isNotEmpty;
        return SizedBox(
          width: 48.w,
          height: 56.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTextStyles.pageTitle,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: isFilled ? AppColors.primary : AppColors.border,
                  width: isFilled ? 1.6 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            onChanged: (value) {
              setState(() {});
              _handleChange(index, value);
            },
          ),
        );
      }),
    );
  }
}
