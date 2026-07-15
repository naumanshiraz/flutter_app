/// Exceptions thrown by Data-layer sources (Remote/Local).
/// These get caught by repositories and mapped into `Failure`s so the
/// Domain/Presentation layers never depend on Data-layer types.
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Something went wrong on the server.']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Unable to read local storage.']);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection.']);
}

class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Session expired. Please log in again.']);
}

/// Thrown when the user denies a requested device permission (camera,
/// photo library, etc).
class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission was denied.']);
}

/// Thrown when the user backs out of the camera/gallery picker without
/// selecting anything — not a real error, just a no-op the caller should
/// silently ignore rather than surface as a failure message.
class ImagePickCancelledException implements Exception {
  const ImagePickCancelledException();
}
