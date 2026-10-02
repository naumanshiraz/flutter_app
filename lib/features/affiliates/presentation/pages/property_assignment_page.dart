import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/core/widgets/labeled_form_field.dart';
import 'package:pms_app/core/widgets/single_select_sheet.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';

const List<String> kAssignableProperties = [
  '215, 21-B, Gerlug Vista',
  '201, 21-B, Gerlug Vista',
  '305, 21-A, Gerlug Vista',
];

class PropertyAssignmentPage extends ConsumerStatefulWidget {
  final Affiliate affiliate;
  final bool readOnly;

  const PropertyAssignmentPage({super.key, required this.affiliate, this.readOnly = false});

  @override
  ConsumerState<PropertyAssignmentPage> createState() => _PropertyAssignmentPageState();
}

class _PropertyAssignmentPageState extends ConsumerState<PropertyAssignmentPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _relationshipController;
  String? _selectedProperty;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.affiliate.name);
    _emailController = TextEditingController(text: widget.affiliate.email);
    _phoneController = TextEditingController(text: widget.affiliate.phone);
    _relationshipController = TextEditingController(text: widget.affiliate.relationship ?? '');
    _selectedProperty = kAssignableProperties.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  Future<void> _pickProperty() async {
    if (widget.readOnly) return;
    final selected = await SingleSelectSheet.show(
      context,
      options: kAssignableProperties,
      current: _selectedProperty,
      title: 'Property assignment',
    );
    if (selected != null) setState(() => _selectedProperty = selected);
  }

  Future<void> _onSave() async {
    if (widget.readOnly) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Property assignment',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp),
        ),
        actions: [
          if (!widget.readOnly)
            IconButton(
              icon: _isSaving
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(strokeWidth: 2.2, valueColor: AlwaysStoppedAnimation(AppColors.primary)),
                    )
                  : const Icon(Icons.check, color: AppColors.textBlack),
              onPressed: _isSaving ? null : _onSave,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LabeledFormField(label: 'Name', controller: _nameController, enabled: false),
              SizedBox(height: 20.h),
              LabeledFormField(label: 'Email', controller: _emailController, enabled: false),
              SizedBox(height: 20.h),
              LabeledFormField(label: 'Phone number', controller: _phoneController, enabled: false),
              SizedBox(height: 20.h),
              LabeledFormField(label: 'Relationship', controller: _relationshipController, enabled: false),
              SizedBox(height: 20.h),
              LabeledPickerField(
                label: 'Property assignment',
                displayValue: _selectedProperty ?? 'Choose',
                isPlaceholder: _selectedProperty == null,
                onTap: _pickProperty,
              ),
              if (!widget.readOnly) ...[
                SizedBox(height: 40.h),
                GradientButton(
                  label: 'Assign property', 
                  isLoading: _isSaving, 
                  onPressed: _onSave,
                  borderRadius: 10.r,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
