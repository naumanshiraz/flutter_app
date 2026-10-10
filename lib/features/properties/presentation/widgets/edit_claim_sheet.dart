import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/properties/domain/entities/available_suite.dart';
import 'package:pms_app/features/properties/domain/entities/residency_request.dart';
import 'package:pms_app/features/properties/presentation/widgets/suite_selection_fields.dart';

class EditClaimSheet extends StatefulWidget {
  final ResidencyRequest request;
  final Future<List<AvailableSuite>?> Function() loadSuites;
  final Future<bool> Function(AvailableSuite suite) onSave;

  const EditClaimSheet({
    super.key,
    required this.request,
    required this.loadSuites,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required ResidencyRequest request,
    required Future<List<AvailableSuite>?> Function() loadSuites,
    required Future<bool> Function(AvailableSuite suite) onSave,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => EditClaimSheet(request: request, loadSuites: loadSuites, onSave: onSave),
    );
  }

  @override
  State<EditClaimSheet> createState() => _EditClaimSheetState();
}

class _EditClaimSheetState extends State<EditClaimSheet> {
  List<AvailableSuite> _suites = const [];
  AvailableSuite? _selected;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  AvailableSuite get _current => AvailableSuite(
        id: widget.request.householdId,
        suite: widget.request.suite,
        floor: widget.request.floor,
        unitType: widget.request.unitType,
        buildingId: '',
        buildingName: widget.request.buildingName,
      );

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final list = await widget.loadSuites();
    if (!mounted) return;
    if (list == null) {
      setState(() {
        _loading = false;
        _error = 'Failed to load suites.';
      });
      return;
    }
    final current = _current;
    final suites = list.any((s) => s.id == current.id) ? list : [current, ...list];
    setState(() {
      _suites = suites;
      _selected = suites.firstWhere((s) => s.id == current.id);
      _loading = false;
    });
  }

  Future<void> _save() async {
    final selected = _selected;
    if (selected == null) return;
    if (selected.id == widget.request.householdId) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    final ok = await widget.onSave(selected);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _saving = false;
        _error = 'Failed to update property.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSave = !_loading && !_saving && _selected != null;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h + MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppColors.textBlack),
                ),
                Text('Edit', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                _saving
                    ? SizedBox(
                        width: 48.w,
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: canSave ? _save : null,
                        icon: Icon(Icons.check, color: canSave ? AppColors.textBlack : AppColors.textSecondary),
                      ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'Please identify the properties you own in this residency. '
              'The information you add here is shared with the system for your convenience.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySecondary,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: _loading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : _suites.isEmpty
                        ? Column(
                            children: [
                              Text(
                                _error ?? 'No suites available.',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(color: AppColors.error),
                              ),
                              TextButton(onPressed: _load, child: const Text('Retry')),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SuiteSelectionFields(
                                suites: _suites,
                                selected: _selected,
                                onSuiteChanged: (s) => setState(() => _selected = s),
                              ),
                              if (_error != null) ...[
                                SizedBox(height: 12.h),
                                Text(
                                  _error!,
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
