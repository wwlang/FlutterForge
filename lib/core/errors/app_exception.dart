import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

/// Application exception hierarchy using sealed classes.
///
/// All expected failure cases are modeled as typed exceptions
/// for exhaustive error handling via pattern matching.
@freezed
sealed class AppException with _$AppException {
  // Validation errors
  /// Validation failed with list of errors.
  const factory AppException.validation(
    List<String> errors, {
    String? field,
  }) = ValidationException;

  // Resource not found
  /// Resource not found at specified path or id.
  const factory AppException.notFound(
    String resource, {
    String? id,
    String? path,
  }) = NotFoundException;

  // Permission errors
  /// Permission denied for operation.
  const factory AppException.permission(
    String operation, {
    String? resource,
    String? suggestion,
  }) = PermissionException;

  // Format errors
  /// File or data format is invalid or corrupted.
  const factory AppException.format(
    String reason, {
    String? path,
    String? expectedFormat,
  }) = FormatException;

  // IO errors
  /// Input/output operation failed.
  const factory AppException.io(
    String operation, {
    String? path,
    Object? originalError,
  }) = IOAppException;

  // State errors
  /// Application state is invalid for the operation.
  const factory AppException.state(
    String message, {
    String? expectedState,
    String? actualState,
  }) = StateException;

  // Unknown/unexpected errors
  /// Unknown or unexpected error occurred.
  const factory AppException.unknown(
    String message, {
    Object? originalError,
    StackTrace? stackTrace,
  }) = UnknownException;
}

/// Extension methods for AppException.
extension AppExceptionX on AppException {
  /// Gets a user-friendly error title.
  String get title {
    return map(
      validation: (_) => 'Validation Error',
      notFound: (_) => 'Not Found',
      permission: (_) => 'Permission Denied',
      format: (_) => 'Invalid Format',
      io: (_) => 'File Error',
      state: (_) => 'Invalid State',
      unknown: (_) => 'Error',
    );
  }

  /// Gets a user-friendly error message.
  String get userMessage {
    return map(
      validation: (e) => e.errors.isNotEmpty
          ? e.errors.first
          : 'Please check your input and try again.',
      notFound: (e) => '${e.resource} could not be found.',
      permission: (e) => 'You do not have permission to ${e.operation}.',
      format: (e) => e.reason,
      io: (e) => 'Failed to ${e.operation}.',
      state: (e) => e.message,
      unknown: (e) => e.message,
    );
  }

  /// Whether this error is recoverable.
  bool get isRecoverable {
    return map(
      validation: (_) => true,
      notFound: (_) => false,
      permission: (_) => true,
      format: (_) => false,
      io: (_) => true,
      state: (_) => true,
      unknown: (_) => false,
    );
  }
}
