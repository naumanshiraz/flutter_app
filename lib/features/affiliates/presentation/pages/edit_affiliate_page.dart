import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/core/widgets/gradient_button.dart';
import 'package:pms_app/features/affiliates/domain/entities/affiliate.dart';
import 'package:pms_app/features/affiliates/presentation/providers/affiliates_provider.dart';
import 'package:pms_app/features/affiliates/presentation/utils/affiliate_validators.dart';
import 'package:pms_app/features/affiliates/presentation/widgets/affiliate_form_fields.dart';

class EditAffiliatePage extends ConsumerStatefulWidget {
  final Affiliate affiliate;

  const EditAffiliatePage({super.key, required this.affiliate});

  @override
  ConsumerState<EditAffiliatePage> createState() => _EditAffiliatePageState();
}

class _EditAffiliatePageState extends ConsumerState<EditAffiliatePage> {
  late final TextEditingController _name;
  late final TextEditingController _contact;
  String? _relationship;
  bool _showErrors = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final a = widget.affiliate;
    _name = TextEditingController(text: a.name);
    _contact = TextEditingController(text: a.email.isNotEmpty ? a.email : a.phone);
    _relationship = a.relationship;
  }

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _showErrors = true);
    final validation = AffiliateValidators.validateDraft(
      name: _name.text,
      contact: _contact.text,
      relationship: _relationship,
    );
    if (validation != null) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    final contact = _contact.text.trim();
    final isEmail = contact.contains('@');
    final updated = widget.affiliate.copyWith(
      name: _name.text.trim(),
      email: isEmail ? contact : '',
      phone: isEmail ? '' : contact,
      relationship: _relationship,
    );
    final ok = await ref.read(affiliatesProvider(null).notifier).updateAffiliate(updated);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = ref.read(affiliatesProvider(null)).errorMessage ?? 'Failed to save changes.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: AppColors.textBlack),
        title: Text('Edit', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700, fontSize: 16.sp)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AffiliateFormFields(
                nameController: _name,
                contactController: _contact,
                relationship: _relationship,
                onRelationshipChanged: (v) => setState(() => _relationship = v),
                showErrors: _showErrors,
              ),
              if (_error != null) ...[
                SizedBox(height: 12.h),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              SizedBox(height: 24.h),
              GradientButton(label: 'Save', isLoading: _saving, onPressed: _save, borderRadius: 10.r),
            ],
          ),
        ),
      ),
    );
  }
}
