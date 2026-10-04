import 'package:equatable/equatable.dart';

class VisitorSchedule extends Equatable {
  final String id;
  final String householdId;
  final String guestName;
  final String licensePlate;
  final String time; // HH:mm
  final String date; // ISO yyyy-MM-dd
  final bool signedUpByMe;
  final DateTime? createdAt;

  const VisitorSchedule({
    required this.id,
    this.householdId = '',
    required this.guestName,
    required this.licensePlate,
    required this.time,
    required this.date,
    this.signedUpByMe = false,
    this.createdAt,
  });

  VisitorSchedule copyWith({
    String? householdId,
    String? guestName,
    String? licensePlate,
    String? time,
    String? date,
  }) {
    return VisitorSchedule(
      id: id,
      householdId: householdId ?? this.householdId,
      guestName: guestName ?? this.guestName,
      licensePlate: licensePlate ?? this.licensePlate,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props =>
      [id, householdId, guestName, licensePlate, time, date, signedUpByMe, createdAt];
}
