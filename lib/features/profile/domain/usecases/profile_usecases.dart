import 'package:pms_app/core/utils/result.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';
import 'package:pms_app/features/profile/domain/repositories/profile_repository.dart';

class GetEditableProfileUseCase {
  final ProfileRepository _repository;
  const GetEditableProfileUseCase(this._repository);

  Future<Result<EditableProfile>> call() => _repository.getProfile();
}

class UpdateProfileUseCase {
  final ProfileRepository _repository;
  const UpdateProfileUseCase(this._repository);

  Future<Result<void>> call(EditableProfile profile) => _repository.updateProfile(profile);
}

class PickProfilePictureUseCase {
  final ProfileRepository _repository;
  const PickProfilePictureUseCase(this._repository);

  Future<Result<String>> call(ProfilePictureSource source) =>
      _repository.pickProfilePicture(source);
}

class UpdateContactIdentifierUseCase {
  final ProfileRepository _repository;
  const UpdateContactIdentifierUseCase(this._repository);

  Future<Result<void>> call({required String field, required String value}) =>
      _repository.updateContactIdentifier(field: field, value: value);
}

class UploadAvatarUseCase {
  final ProfileRepository _repository;
  const UploadAvatarUseCase(this._repository);

  Future<Result<String>> call(String filePath) => _repository.uploadAvatar(filePath);
}

class DeleteAvatarUseCase {
  final ProfileRepository _repository;
  const DeleteAvatarUseCase(this._repository);

  Future<Result<void>> call() => _repository.deleteAvatar();
}
