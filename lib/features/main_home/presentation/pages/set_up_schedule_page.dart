import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pms_app/core/theme/app_colors.dart';
import 'package:pms_app/core/theme/app_text_styles.dart';
import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';

class SetUpSchedulePage extends StatefulWidget {
  final VisitorSchedule? initial;

  const SetUpSchedulePage({Key? key, this.initial}) : super(key: key);

  @override
  State<SetUpSchedulePage> createState() => _SetUpSchedulePageState();
}

class _SetUpSchedulePageState extends State<SetUpSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _guestCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();
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
    Navigator.of(context).pop<VisitorSchedule?>(
      VisitorSchedule(
        id: widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        guestName: _guestCtrl.text.trim(),
        licensePlate: _plateCtrl.text.trim(),
        time: timeStr,
        date: dateStr,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.initial == null ? 'Set up a new schedule' : 'Edit schedule', style: AppTextStyles.pageTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _guestCtrl,
                decoration: const InputDecoration(labelText: 'Guest name'),
                validator: (s) => (s == null || s.trim().isEmpty) ? 'Enter guest name' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _plateCtrl,
                decoration: const InputDecoration(labelText: 'License plate number'),
                validator: (s) => (s == null || s.trim().isEmpty) ? 'Enter license plate' : null,
              ),
              SizedBox(height: 12.h),
              InkWell(
                onTap: _pickTime,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Time'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('${_time.format(context)}'), const Icon(Icons.keyboard_arrow_down)],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(_date.toLocal().toIso8601String().split('T').first), const Icon(Icons.keyboard_arrow_down)],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: EdgeInsets.symmetric(vertical: 14.h)),
                  child: Text('Set up', style: AppTextStyles.body.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}