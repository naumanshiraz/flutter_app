import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';

class VisitorModel {
  final String id;
  final String householdId;
  final String guestName;
  final String licensePlate;
  final String time;
  final String date;
  final bool signedUpByMe;

  const VisitorModel({
    required this.id,
    required this.householdId,
    required this.guestName,
    required this.licensePlate,
    required this.time,
    required this.date,
    this.signedUpByMe = false,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json, {String householdId = ''}) {
    return VisitorModel(
      id: json['id'] as String,
      householdId: householdId,
      guestName: json['guest_name'] as String,
      licensePlate: json['license_plate'] as String,
      time: json['expected_time'] as String,
      date: json['expected_on'] as String,
      signedUpByMe: json['signed_up_by_me'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'guest_name': guestName,
    'license_plate': licensePlate,
    'expected_on': date,
    'expected_time': time,
    'signed_up_by_me': signedUpByMe,
  };

  VisitorSchedule toEntity() => VisitorSchedule(
    id: id,
    householdId: householdId,
    guestName: guestName,
    licensePlate: licensePlate,
    time: time,
    date: date,
    signedUpByMe: signedUpByMe,
  );

  static VisitorModel fromEntity(VisitorSchedule e) => VisitorModel(
    id: e.id,
    householdId: e.householdId,
    guestName: e.guestName,
    licensePlate: e.licensePlate,
    time: e.time,
    date: e.date,
    signedUpByMe: e.signedUpByMe,
  );
}
