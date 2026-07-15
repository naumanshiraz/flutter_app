import 'package:equatable/equatable.dart';

/// The full editable profile shown on the Edit Profile screen. A
/// superset of `auth`'s onboarding `UserProfile` (adds country,
/// pronouns, avatar) — kept as its own entity so this module stays
/// self-contained and doesn't reach into another feature's domain layer.
class EditableProfile extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String? country;
  final DateTime? birthDate;
  final String? pronouns;
  final String? avatarPath;

  const EditableProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.country,
    this.birthDate,
    this.pronouns,
    this.avatarPath,
  });

  /// "Narandelger Dashdorj" -> "ND", shown in the placeholder avatar
  /// circle whenever there's no [avatarPath] yet.
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
  }) {
    return EditableProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      pronouns: pronouns ?? this.pronouns,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  @override
  List<Object?> get props => [name, email, phone, country, birthDate, pronouns, avatarPath];
}

/// Where the picked photo comes from — kept in the domain layer as a
/// plain enum so use cases don't depend on `image_picker`'s own type.
enum ProfilePictureSource { camera, gallery }
