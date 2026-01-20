import 'package:flutter_forge/core/errors/app_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Result type for operations that can fail.
///
/// Use pattern matching for exhaustive handling:
/// ```dart
/// final result = await loadProject(path);
/// return switch (result) {
///   Success(:final data) => ProjectScreen(project: data),
///   Failure(:final error) => ErrorScreen(error: error),
/// };
/// ```
@freezed
sealed class Result<T> with _$Result<T> {
  /// Operation succeeded with data.
  const factory Result.success(T data) = Success<T>;

  /// Operation failed with error.
  const factory Result.failure(AppException error) = Failure<T>;
}

/// Extension methods for Result type.
extension ResultExtension<T> on Result<T> {
  /// Returns the success value or null if failure.
  T? get valueOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// Returns the error or null if success.
  AppException? get errorOrNull => switch (this) {
        Success() => null,
        Failure(:final error) => error,
      };

  /// Returns true if this is a success result.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result.
  bool get isFailure => this is Failure<T>;

  /// Maps the success value to a new type.
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
        Success(:final data) => Result.success(transform(data)),
        Failure(:final error) => Result.failure(error),
      };

  /// Maps the success value to a new Result.
  Result<R> flatMap<R>(Result<R> Function(T data) transform) => switch (this) {
        Success(:final data) => transform(data),
        Failure(:final error) => Result.failure(error),
      };
}
