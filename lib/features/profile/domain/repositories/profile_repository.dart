import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';

/// Domain contract for viewing/editing the profile and picking a new
/// profile picture. Presentation depends only on this interface.
abstract class ProfileRepository {
  /// Reads whatever profile currently exists locally (cached during
  /// onboarding, or previously edited here).
  Future<Result<EditableProfile>> getProfile();

  /// Persists the given [profile] — locally today, `PATCH /user/profile`
  /// once a backend exists.
  Future<Result<void>> updateProfile(EditableProfile profile);

  /// Launches the camera or gallery via [source], and returns the local
  /// path of the picked image. Does not persist it onto the profile —
  /// the caller decides when to commit that via [updateProfile].
  Future<Result<String>> pickProfilePicture(ProfilePictureSource source);
}
