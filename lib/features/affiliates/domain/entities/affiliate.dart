import 'package:equatable/equatable.dart';

class Affiliate extends Equatable {
  final String id;
  final String? householdId;
  final String name;
  final String email;
  final String phone;
  final String? relationship;
  final String status;

  const Affiliate({
    required this.id,
    this.householdId,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.relationship,
    this.status = 'Pending',
  });

  bool get isTenant => relationship == 'Tenant';

  Affiliate copyWith({
    String? householdId,
    String? name,
    String? email,
    String? phone,
    String? relationship,
    String? status,
  }) {
    return Affiliate(
      id: id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, householdId, name, email, phone, relationship, status];
}
