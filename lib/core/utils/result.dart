import 'package:pms_app/core/error/failures.dart';

/// Lightweight `Either`-style result so repositories never throw across
/// layer boundaries. Uses Dart 3 sealed classes + pattern matching instead
/// of pulling in a functional-programming package.
sealed class Result<T> {
  const Result();

  /// Pattern-match helper: exactly one of [onSuccess]/[onFailure] runs.
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    final self = this;
    if (self is Success<T>) return onSuccess(self.data);
    if (self is ResultError<T>) return onFailure(self.failure);
    throw StateError('Unreachable: unknown Result subtype');
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultError<T>;

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  Failure? get failureOrNull =>
      this is ResultError<T> ? (this as ResultError<T>).failure : null;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Named `ResultError` (not `Error`) to avoid shadowing Dart's built-in
/// `dart:core` `Error` class.
class ResultError<T> extends Result<T> {
  final Failure failure;
  const ResultError(this.failure);
}
