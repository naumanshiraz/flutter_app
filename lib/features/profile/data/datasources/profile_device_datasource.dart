import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pms_app/core/error/exceptions.dart';
import 'package:pms_app/features/profile/domain/entities/editable_profile.dart';

/// Wraps `image_picker` + `permission_handler`. Kept separate from
/// [ProfileRemoteDataSource]/[ProfileLocalDataSource] since it talks to
/// the device (camera/gallery), not the network or Hive.
abstract class ProfileDeviceDataSource {
  /// Requests the relevant permission, then launches the camera or
  /// gallery per [source]. Returns the picked image's local file path.
  /// Throws a [PermissionException] if the user denies access.
  Future<String> pickImage(ProfilePictureSource source);
}

class ProfileDeviceDataSourceImpl implements ProfileDeviceDataSource {
  final ImagePicker _picker;

  ProfileDeviceDataSourceImpl({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  @override
  Future<String> pickImage(ProfilePictureSource source) async {
    final permission = source == ProfilePictureSource.camera ? Permission.camera : Permission.photos;

    final status = await permission.request();
    if (!status.isGranted) {
      throw PermissionException(
        source == ProfilePictureSource.camera
            ? 'Camera permission was denied. Enable it in Settings to take a photo.'
            : 'Photo library permission was denied. Enable it in Settings to choose a photo.',
      );
    }

    final XFile? picked = await _picker.pickImage(
      source: source == ProfilePictureSource.camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1080,
    );

    if (picked == null) {
      throw const ImagePickCancelledException();
    }

    return picked.path;
  }
}
