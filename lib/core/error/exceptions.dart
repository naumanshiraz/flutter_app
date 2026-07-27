/// Exceptions thrown by Data-layer sources (Remote/Local).
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

class PermissionException implements Exception {
  final String message;
  const PermissionException([this.message = 'Permission was denied.']);
}

/// Thrown when the user backs out of the camera/gallery picker without selecting anything
class ImagePickCancelledException implements Exception {
  const ImagePickCancelledException();
}
