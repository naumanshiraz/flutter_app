import 'package:equatable/equatable.dart';

/// A single family member / affiliate, as shown in the "Please identify
/// your affiliates" step: name, contact info, relationship, birth year,
/// gender.
class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? relationship;
  final int? birthYear;
  final String? gender;

  const FamilyMember({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.relationship,
    this.birthYear,
    this.gender,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      relationship != null &&
      birthYear != null &&
      gender != null;

  FamilyMember copyWith({
    String? name,
    String? email,
    String? phone,
    String? relationship,
    int? birthYear,
    String? gender,
  }) {
    return FamilyMember(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      birthYear: birthYear ?? this.birthYear,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, relationship, birthYear, gender];
}
