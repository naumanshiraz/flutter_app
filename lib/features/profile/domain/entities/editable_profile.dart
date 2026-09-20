import 'package:equatable/equatable.dart';

class EditableProfile extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String? country;
  final DateTime? birthDate;
  final String? pronouns;
  final String? avatarPath;
  final String? avatarUrl;

  const EditableProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.country,
    this.birthDate,
    this.pronouns,
    this.avatarPath,
    this.avatarUrl,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  EditableProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? country,
    DateTime? birthDate,
    String? pronouns,
    String? avatarPath,
    String? avatarUrl,
  }) {
    return EditableProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      pronouns: pronouns ?? this.pronouns,
      avatarPath: avatarPath ?? this.avatarPath,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props =>
      [name, email, phone, country, birthDate, pronouns, avatarPath, avatarUrl];
}

enum ProfilePictureSource { camera, gallery }
