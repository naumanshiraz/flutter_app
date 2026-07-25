import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';

class SetUpScheduleSheet extends StatefulWidget {
  final VisitorSchedule? initial;

  const SetUpScheduleSheet({Key? key, this.initial}) : super(key: key);

  @override
  State<SetUpScheduleSheet> createState() => _SetUpScheduleSheetState();
}

class _SetUpScheduleSheetState extends State<SetUpScheduleSheet> {
  final _formKey = GlobalKey<FormState>();
  final _guestCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
  final FocusNode _guestFocus = FocusNode();
  final FocusNode _plateFocus = FocusNode();

  TimeOfDay _time = TimeOfDay.now();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();

    final i = widget.initial;
    if (i != null) {
      _guestCtrl.text = i.guestName;
      _plateCtrl.text = i.licensePlate;
      final parts = i.time.split(':');
      if (parts.length == 2) {
        _time = TimeOfDay(hour: int.tryParse(parts[0]) ?? 0, minute: int.tryParse(parts[1]) ?? 0);
      }
      _date = DateTime.tryParse(i.date) ?? DateTime.now();
    }

    // Debug focus events
    _guestFocus.addListener(() => debugPrint('Guest focus: ${_guestFocus.hasFocus}'));
    _plateFocus.addListener(() => debugPrint('Plate focus: ${_plateFocus.hasFocus}'));
  }

  @override
  void dispose() {
    _guestCtrl.dispose();
    _plateCtrl.dispose();
    _guestFocus.dispose();
    _plateFocus.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _date = d);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final timeStr = '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';
    final dateStr = _date.toIso8601String().split('T').first;
    final schedule = VisitorSchedule(
      id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      guestName: _guestCtrl.text.trim(),
      licensePlate: _plateCtrl.text.trim(),
      time: timeStr,
      date: dateStr,
    );
    Navigator.of(context).pop(schedule);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomInset = mq.viewInsets.bottom;
    final sheetHeight = mq.size.height * 0.78;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: sheetHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, -4))],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Row(
                  children: [
                    IconButton(onPressed: () => Navigator.of(context).pop<VisitorSchedule?>(null), icon: Icon(Icons.close, size: 22.sp, color: AppColors.textSecondary)),
                    Expanded(
                      child: Column(
                        children: [
                          Container(width: 36.w, height: 4.h, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4.r))),
                          SizedBox(height: 8.h),
                          Text('Set up a new schedule', style: AppTextStyles.pageTitle),
                        ],
                      ),
                    ),
                    IconButton(onPressed: _submit, icon: Icon(Icons.check, size: 22.sp, color: AppColors.primary)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Please let us know the details of your guest\'s vehicles. Your contribution is vital to our property management system for maintaining your convenience.',
                  style: AppTextStyles.caption,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 24.h + bottomInset),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _guestCtrl,
                          focusNode: _guestFocus,
                          autofocus: true,
                          decoration: const InputDecoration(labelText: 'Guest name'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          onTap: () {
                            debugPrint('guest tapped (onTap)');
                          },
                          validator: (s) => (s == null || s.trim().isEmpty) ? 'Enter guest name' : null,
                        ),
                        SizedBox(height: 12.h),
                        TextFormField(
                          controller: _plateCtrl,
                          focusNode: _plateFocus,
                          decoration: const InputDecoration(labelText: 'License plate number'),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onTap: () {
                            debugPrint('plate tapped (onTap)');
                          },
                          validator: (s) => (s == null || s.trim().isEmpty) ? 'Enter license plate' : null,
                        ),
                        SizedBox(height: 12.h),
                        InkWell(
                          onTap: _pickTime,
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Time'),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('${_time.format(context)}'), const Icon(Icons.keyboard_arrow_down)]),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Date'),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(_date.toLocal().toIso8601String().split('T').first), const Icon(Icons.keyboard_arrow_down)]),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.symmetric(vertical: 14.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
                            child: Text('Set up', style: AppTextStyles.body.copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}