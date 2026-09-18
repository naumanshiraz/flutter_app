import 'package:equatable/equatable.dart';

enum Gender { female, male, other }

class UserProfile extends Equatable {
  final String name;
  final DateTime? birthDate;
  final Gender? gender;
  final String? customGender;
  final String? location;

  const UserProfile({
    this.name = '',
    this.birthDate,
    this.gender,
    this.customGender,
    this.location,
  });

  bool get isComplete =>
      name.isNotEmpty && birthDate != null && gender != null && location != null && location!.isNotEmpty;

  UserProfile copyWith({
    String? name,
    DateTime? birthDate,
    Gender? gender,
    String? customGender,
    bool clearCustomGender = false,
    String? location,
  }) {
    return UserProfile(
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      customGender: clearCustomGender ? null : (customGender ?? this.customGender),
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [name, birthDate, gender, customGender, location];
}
