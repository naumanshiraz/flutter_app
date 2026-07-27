import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Unable to read local storage.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired. Please log in again.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission was denied.']);
}

/// Not a real error — the user simply backed out of the camera/gallery
/// picker. A dedicated type (rather than a magic error message) lets
/// callers use `is PickCancelledFailure` to silently ignore it.
class PickCancelledFailure extends Failure {
  const PickCancelledFailure() : super('cancelled');
}
