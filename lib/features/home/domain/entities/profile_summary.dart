import 'package:equatable/equatable.dart';

/// The condensed profile shown at the top of Home — not the full
/// onboarding [UserProfile], just what's needed for this header.
class ProfileSummary extends Equatable {
  final String name;
  final String email;
  final String phone;

  /// Either a real `https://` URL (once a backend serves uploaded
  /// avatars) or, today, a local device file path — the profile picture
  /// picker has no backend to upload to yet, so it stores the picked
  /// image's on-device path here directly. `ProfileHeader` inspects the
  /// value and renders local paths with `Image.file`, remote URLs with
  /// `CachedNetworkImage`.
  final String? avatarUrl;

  const ProfileSummary({
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
  });

  /// "Narandelger Dashdorj" -> "ND", used as the avatar fallback when
  /// there's no [avatarUrl].
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  @override
  List<Object?> get props => [name, email, phone, avatarUrl];
}
