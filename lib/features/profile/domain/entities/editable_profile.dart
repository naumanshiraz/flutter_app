import 'package:equatable/equatable.dart';

class EditableProfile extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String? country;
  final DateTime? birthDate;
  final String? avatarPath;
  final String? avatarUrl;

  const EditableProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.country,
    this.birthDate,
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
    String? avatarPath,
    bool clearAvatarPath = false,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) {
    return EditableProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      avatarPath: clearAvatarPath ? null : (avatarPath ?? this.avatarPath),
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
    );
  }

  @override
  List<Object?> get props => [name, email, phone, country, birthDate, avatarPath, avatarUrl];
}

enum ProfilePictureSource { camera, gallery }
