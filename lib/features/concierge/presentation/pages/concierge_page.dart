import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/concierge/presentation/widgets/concierge_content_view.dart';

class ConciergePage extends StatelessWidget {
  const ConciergePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Concierge', style: AppTextStyles.appTitle),
              ),
            ),
            const Expanded(child: ConciergeContentView()),
          ],
        ),
      ),
    );
  }
}
