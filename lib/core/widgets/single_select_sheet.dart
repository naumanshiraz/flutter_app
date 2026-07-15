import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

/// Generic single-choice bottom sheet — pairs with [LabeledPickerField].
/// Returns the selected item via `Navigator.pop(context, item)`, or
/// `null` if dismissed without choosing.
class SingleSelectSheet extends StatelessWidget {
  final List<String> options;
  final String? current;
  final String? title;

  const SingleSelectSheet({
    super.key,
    required this.options,
    this.current,
    this.title,
  });

  /// Convenience launcher so callers don't need to know the sheet's
  /// styling/shape boilerplate.
  static Future<String?> show(
    BuildContext context, {
    required List<String> options,
    String? current,
    String? title,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SingleSelectSheet(options: options, current: current, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 12.h),
                  child: Text(title!, style: AppTextStyles.pageTitle.copyWith(fontSize: 16.sp)),
                ),
              ],
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final bool isSelected = option == current;
                    return ListTile(
                      title: Text(option, style: AppTextStyles.body),
                      trailing:
                          isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () => Navigator.of(context).pop(option),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
