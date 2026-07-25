import 'package:equatable/equatable.dart';

class VisitorSchedule extends Equatable {
  final String id;
  final String guestName;
  final String licensePlate;
  final String time; // HH:mm
  final String date; // ISO yyyy-MM-dd

  const VisitorSchedule({
    required this.id,
    required this.guestName,
    required this.licensePlate,
    required this.time,
    required this.date,
  });

  VisitorSchedule copyWith({
    String? guestName,
    String? licensePlate,
    String? time,
    String? date,
  }) {
    return VisitorSchedule(
      id: id,
      guestName: guestName ?? this.guestName,
      licensePlate: licensePlate ?? this.licensePlate,
      time: time ?? this.time,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [id, guestName, licensePlate, time, date];
}