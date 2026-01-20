import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

/// Application exception hierarchy using sealed classes.
///
/// All expected failure cases are modeled as typed exceptions
/// for exhaustive error handling via pattern matching.
@freezed
sealed class AppException with _$AppException {
  // File operations
  /// File not found at specified path.
  const factory AppException.fileNotFound(String path) = FileNotFoundException;

  /// Permission denied for file operation.
  const factory AppException.filePermission(String path) =
      FilePermissionException;

  /// File format is invalid or corrupted.
  const factory AppException.invalidFormat(String reason) =
      InvalidFormatException;

  // Project operations
  /// Project data is invalid or incomplete.
  const factory AppException.invalidProject(String reason) =
      InvalidProjectException;

  /// Widget node not found in project.
  const factory AppException.nodeNotFound(String id) = NodeNotFoundException;

  // Code generation
  /// Code generation failed.
  const factory AppException.codeGeneration(String message) =
      CodeGenerationException;

  // Validation
  /// Validation failed with list of errors.
  const factory AppException.validation(List<String> errors) =
      ValidationException;
}
