import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String contact; // email or phone number
  final String? relationship;

  const FamilyMember({
    required this.id,
    this.name = '',
    this.contact = '',
    this.relationship,
  });

  bool get isValid =>
      name.trim().isNotEmpty && contact.trim().isNotEmpty && relationship != null;

  FamilyMember copyWith({String? name, String? contact, String? relationship}) {
    return FamilyMember(
      id: id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      relationship: relationship ?? this.relationship,
    );
  }

  @override
  List<Object?> get props => [id, name, contact, relationship];
}
