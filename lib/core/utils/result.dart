import '../errors/app_exception.dart';

/// Result pattern for handling success and error states
sealed class Result<T> {
  const Result();

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Failure<T>;

  /// Returns the success value if this is a success result, otherwise null
  T? get successValue => isSuccess ? (this as Success<T>).value : null;

  /// Returns the failure value if this is a failure result, otherwise null
  AppException? get failureValue =>
      isFailure ? (this as Failure<T>).exception : null;

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T value) mapper) {
    return when(
      success: (value) => Success(mapper(value)),
      failure: (exception) => Failure(exception),
    );
  }

  /// Maps the failure value to a new type
  Result<T> mapFailure(AppException Function(AppException exception) mapper) {
    return when(
      success: (value) => Success(value),
      failure: (exception) => Failure(mapper(exception)),
    );
  }

  /// Executes a function based on whether this is a success or failure
  R when<R>({
    required R Function(T value) success,
    required R Function(AppException exception) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    } else if (this is Failure<T>) {
      return failure((this as Failure<T>).exception);
    } else {
      throw StateError('Result is neither Success nor Failure');
    }
  }

  /// Executes a function only if this is a success result
  Result<T> onSuccess(void Function(T value) callback) {
    if (isSuccess) {
      callback(successValue!);
    }
    return this;
  }

  /// Executes a function only if this is a failure result
  Result<T> onFailure(void Function(AppException exception) callback) {
    if (isFailure) {
      callback(failureValue!);
    }
    return this;
  }

  /// Returns the success value or throws the exception
  T getOrThrow() {
    return when(
      success: (value) => value,
      failure: (exception) => throw exception,
    );
  }

  /// Returns the success value or a default value
  T getOrElse(T defaultValue) {
    return when(success: (value) => value, failure: (_) => defaultValue);
  }

  /// Returns the success value or null
  T? getOrNull() {
    return when(success: (value) => value, failure: (_) => null);
  }
}

/// Success result
class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failure result
class Failure<T> extends Result<T> {
  final AppException exception;

  const Failure(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Failure($exception)';
}

/// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  /// Returns the success value or a default value
  T orElse(T defaultValue) => getOrElse(defaultValue);

  /// Returns the success value or null
  T? orNull() => getOrNull();

  /// Returns the success value or throws the exception
  T orThrow() => getOrThrow();

  /// Executes a function only if this is a success result
  Result<T> tap(void Function(T value) callback) => onSuccess(callback);

  /// Executes a function only if this is a failure result
  Result<T> tapError(void Function(AppException exception) callback) =>
      onFailure(callback);
}
