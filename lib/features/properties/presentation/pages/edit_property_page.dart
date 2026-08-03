import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/router/route_names.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/placeholder_page.dart';
import 'package:pms_app/features/properties/domain/entities/property.dart';
import 'package:pms_app/features/properties/presentation/providers/properties_provider.dart';
import 'package:pms_app/features/properties/presentation/widgets/property_form_fields.dart';

class EditPropertyPage extends ConsumerStatefulWidget {
  final Property property;

  const EditPropertyPage({super.key, required this.property});

  @override
  ConsumerState<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends ConsumerState<EditPropertyPage> {
  late final TextEditingController _suiteController;
  late String? _floor;
  late String? _type;
  late String? _building;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _suiteController = TextEditingController(text: widget.property.suite);
    _floor = widget.property.floor;
    _type = widget.property.type;
    _building = widget.property.building;
  }

  @override
  void dispose() {
    _suiteController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final updated = widget.property.copyWith(
      suite: _suiteController.text.trim(),
      floor: _floor,
      type: _type,
      building: _building,
    );

    if (!updated.isValid) {
      setState(() => _errorMessage = 'Please complete every field.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final ok = await ref.read(propertiesProvider.notifier).updateProperty(updated);

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      setState(() {
        _isSaving = false;
        _errorMessage = ref.read(propertiesProvider).errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Edit',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageTitle.copyWith(fontSize: 17.sp),
                    ),
                  ),
                  IconButton(
                    icon: _isSaving
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          )
                        : const Icon(Icons.check, color: AppColors.textPrimary),
                    onPressed: _isSaving ? null : _onSave,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please identify the properties you own in this '
                      'residency. The information you add here is shared '
                      'with the system for your convenience.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySecondary,
                    ),
                    SizedBox(height: 24.h),
                    PropertyFormFields(
                      suiteController: _suiteController,
                      floor: _floor,
                      type: _type,
                      building: _building,
                      onFloorChanged: (v) => setState(() => _floor = v),
                      onTypeChanged: (v) => setState(() => _type = v),
                      onBuildingChanged: (v) => setState(() => _building = v),
                    ),
                    if (_errorMessage != null) ...[
                      SizedBox(height: 16.h),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(color: AppColors.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Defensive fallback for the (unlikely) case someone deep-links to the
/// edit route without a property in `state.extra`.
class EditPropertyFallbackPage extends StatelessWidget {
  const EditPropertyFallbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Edit Property',
      routeName: RouteNames.editProperty,
    );
  }
}
