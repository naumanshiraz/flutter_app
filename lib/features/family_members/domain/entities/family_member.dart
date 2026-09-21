import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? relationship;
  final String invitationStatus;

  const FamilyMember({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.relationship,
    this.invitationStatus = 'Pending',
  });

  bool get isValid =>
      (email.trim().isNotEmpty || phone.trim().isNotEmpty) && relationship != null;

  FamilyMember copyWith({
    String? name,
    String? email,
    String? phone,
    String? relationship,
    String? invitationStatus,
  }) {
    return FamilyMember(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      invitationStatus: invitationStatus ?? this.invitationStatus,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, relationship, invitationStatus];
}
