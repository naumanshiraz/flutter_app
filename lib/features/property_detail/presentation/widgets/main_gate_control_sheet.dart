import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';

class MainGateControlSheet extends StatefulWidget {
  const MainGateControlSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) => const MainGateControlSheet(),
    );
  }

  @override
  State<MainGateControlSheet> createState() => _MainGateControlSheetState();
}

class _MainGateControlSheetState extends State<MainGateControlSheet> {
  // Mock member access state; no backend yet.
  final Map<String, bool> _family = {
    'Dulamjav Jargal': true,
    'Narandelger Naran': false,
    'Andrea John': true,
    'Ed Boulivar': false,
    'Smith Snow': false,
  };

  final Map<String, bool> _tenant = {
    'Dulmaa Jargal': true,
    'Dorj Duma': false,
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              _header(context),
              Divider(height: 1, color: AppColors.border),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  children: [
                    _sectionLabel('Family'),
                    ..._family.keys.map((name) => _row(name, _family[name]!, (v) => setState(() => _family[name] = v))),
                    SizedBox(height: 12.h),
                    _sectionLabel('Tenant'),
                    ..._tenant.keys.map((name) => _row(name, _tenant[name]!, (v) => setState(() => _tenant[name] = v))),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 20.w, 12.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 26.sp),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Main gate control',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle.copyWith(fontSize: 16.sp),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(label, style: AppTextStyles.bodySecondary.copyWith(fontSize: 12.sp)),
    );
  }

  Widget _row(String name, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, fontSize: 14.sp)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.textSecondary.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}
