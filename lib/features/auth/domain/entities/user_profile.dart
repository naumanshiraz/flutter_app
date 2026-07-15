import 'package:equatable/equatable.dart';

enum Gender { female, male, other }

/// The profile collected across the 5 onboarding steps (email, phone,
/// name + birthdate, gender, location). Immutable — every step produces
/// a new copy via [copyWith].
class UserProfile extends Equatable {
  final String email;
  final String phone;
  final String name;
  final DateTime? birthDate;
  final Gender? gender;
  final String? customGender;
  final String? location;

  const UserProfile({
    this.email = '',
    this.phone = '',
    this.name = '',
    this.birthDate,
    this.gender,
    this.customGender,
    this.location,
  });

  bool get isComplete =>
      email.isNotEmpty &&
      phone.isNotEmpty &&
      name.isNotEmpty &&
      birthDate != null &&
      gender != null &&
      location != null &&
      location!.isNotEmpty;

  UserProfile copyWith({
    String? email,
    String? phone,
    String? name,
    DateTime? birthDate,
    Gender? gender,
    String? customGender,
    bool clearCustomGender = false,
    String? location,
  }) {
    return UserProfile(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      customGender: clearCustomGender ? null : (customGender ?? this.customGender),
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props =>
      [email, phone, name, birthDate, gender, customGender, location];
}
