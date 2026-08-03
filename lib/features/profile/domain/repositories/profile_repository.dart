import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';

abstract class ProfileRepository {
  Future<Result<EditableProfile>> getProfile();

  Future<Result<void>> updateProfile(EditableProfile profile);

  Future<Result<String>> pickProfilePicture(ProfilePictureSource source);
}
