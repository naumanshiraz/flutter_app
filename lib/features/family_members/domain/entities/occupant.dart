import 'package:equatable/equatable.dart';

class Occupant extends Equatable {
  final String userId;
  final String fullName;
  final bool isPrimary;
  final String? relation;
  final bool canUseDevices;
  final DateTime? movedInAt;
  final bool sponsoredByMe;

  const Occupant({
    required this.userId,
    required this.fullName,
    this.isPrimary = false,
    this.relation,
    this.canUseDevices = false,
    this.movedInAt,
    this.sponsoredByMe = false,
  });

  bool get isTenant => relation?.toLowerCase() == 'tenant';

  @override
  List<Object?> get props =>
      [userId, fullName, isPrimary, relation, canUseDevices, movedInAt, sponsoredByMe];
}
