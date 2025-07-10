/// Base exception class for the application
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => 'AppException: $message';
}

/// Exception thrown when there's a network error
class NetworkException extends AppException {
  const NetworkException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when there's a storage error
class StorageException extends AppException {
  const StorageException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'StorageException: $message';
}

/// Exception thrown when there's an API error
class ApiException extends AppException {
  final int? statusCode;

  const ApiException(
    String message, {
    String? code,
    this.statusCode,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception thrown when there's a validation error
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    String message, {
    String? code,
    this.fieldErrors,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception thrown when there's a permission error
class PermissionException extends AppException {
  const PermissionException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'PermissionException: $message';
}

/// Exception thrown when there's a data parsing error
class ParsingException extends AppException {
  const ParsingException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'ParsingException: $message';
}

/// Exception thrown when there's an AI service error
class AiServiceException extends AppException {
  const AiServiceException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'AiServiceException: $message';
}

/// Exception thrown when there's a file operation error
class FileException extends AppException {
  const FileException(String message, {String? code, dynamic originalError})
    : super(message, code: code, originalError: originalError);

  @override
  String toString() => 'FileException: $message';
}
