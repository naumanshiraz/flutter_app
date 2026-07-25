import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';

class VisitorModel {
  final String id;
  final String guestName;
  final String licensePlate;
  final String time;
  final String date;

  const VisitorModel({
    required this.id,
    required this.guestName,
    required this.licensePlate,
    required this.time,
    required this.date,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'] as String,
      guestName: json['guestName'] as String,
      licensePlate: json['licensePlate'] as String,
      time: json['time'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'guestName': guestName,
    'licensePlate': licensePlate,
    'time': time,
    'date': date,
  };

  VisitorSchedule toEntity() => VisitorSchedule(
    id: id,
    guestName: guestName,
    licensePlate: licensePlate,
    time: time,
    date: date,
  );

  static VisitorModel fromEntity(VisitorSchedule e) => VisitorModel(
    id: e.id,
    guestName: e.guestName,
    licensePlate: e.licensePlate,
    time: e.time,
    date: e.date,
  );
}