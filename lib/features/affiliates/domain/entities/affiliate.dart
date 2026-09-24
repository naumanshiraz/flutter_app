import 'package:equatable/equatable.dart';

class Affiliate extends Equatable {
  final String id;
  final String propertyId;
  final String name;
  final String email;
  final String phone;
  final String? relationship;
  final String status;

  const Affiliate({
    required this.id,
    required this.propertyId,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.relationship,
    this.status = 'Pending',
  });

  bool get isTenant => relationship == 'Tenant';

  Affiliate copyWith({
    String? propertyId,
    String? name,
    String? email,
    String? phone,
    String? relationship,
    String? status,
  }) {
    return Affiliate(
      id: id,
      propertyId: propertyId ?? this.propertyId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, propertyId, name, email, phone, relationship, status];
}
