import 'package:pms_app/features/main_home/domain/entities/visitor_schedule.dart';

class VisitorModel {
  final String id;
  final String householdId;
  final String guestName;
  final String licensePlate;
  final String time;
  final String date;
  final bool signedUpByMe;
  final DateTime? createdAt;

  const VisitorModel({
    required this.id,
    required this.householdId,
    required this.guestName,
    required this.licensePlate,
    required this.time,
    required this.date,
    this.signedUpByMe = false,
    this.createdAt,
  });

  /// [householdId] isn't in the payload — the API scopes visitors by the
  /// household in the URL (GET /households/{householdId}/visitors) — so the
  /// datasource passes it in after fetching.
  factory VisitorModel.fromJson(Map<String, dynamic> json, {String householdId = ''}) {
    return VisitorModel(
      id: json['id'] as String,
      householdId: householdId,
      guestName: json['guest_name'] as String,
      licensePlate: json['license_plate'] as String,
      time: json['expected_time'] as String,
      date: json['expected_on'] as String,
      signedUpByMe: json['signed_up_by_me'] as bool? ?? false,
      createdAt: json['created_at'] == null ? null : DateTime.tryParse(json['created_at'] as String),
    );
  }

  /// Body for POST /households/{householdId}/visitors — only the 4 fields
  /// the API accepts for creating a schedule.
  Map<String, dynamic> toCreateJson() => {
    'guest_name': guestName,
    'license_plate': licensePlate,
    'expected_on': date,
    'expected_time': time,
  };

  VisitorSchedule toEntity() => VisitorSchedule(
    id: id,
    householdId: householdId,
    guestName: guestName,
    licensePlate: licensePlate,
    time: time,
    date: date,
    signedUpByMe: signedUpByMe,
    createdAt: createdAt,
  );

  static VisitorModel fromEntity(VisitorSchedule e) => VisitorModel(
    id: e.id,
    householdId: e.householdId,
    guestName: e.guestName,
    licensePlate: e.licensePlate,
    time: e.time,
    date: e.date,
    signedUpByMe: e.signedUpByMe,
    createdAt: e.createdAt,
  );
}
