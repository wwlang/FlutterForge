import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter_forge/core/errors/app_exception.dart';

/// Callback type for error reporting.
typedef ErrorReportCallback = void Function(
  Object error,
  StackTrace? stackTrace,
  ErrorContext context,
);

/// Context information for errors.
class ErrorContext {
  const ErrorContext({
    required this.operation,
    this.details = const {},
    this.timestamp,
  });

  /// The operation that was being performed when the error occurred.
  final String operation;

  /// Additional context details.
  final Map<String, dynamic> details;

  /// When the error occurred.
  final DateTime? timestamp;

  /// Creates a copy with updated values.
  ErrorContext copyWith({
    String? operation,
    Map<String, dynamic>? details,
    DateTime? timestamp,
  }) {
    return ErrorContext(
      operation: operation ?? this.operation,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    final ts = timestamp ?? DateTime.now();
    return 'ErrorContext(operation: $operation, time: $ts, details: $details)';
  }
}

/// Centralized error handling for the application.
class ErrorHandler {
  ErrorHandler._();

  static final _instance = ErrorHandler._();

  /// Singleton instance.
  static ErrorHandler get instance => _instance;

  final List<ErrorReportCallback> _reporters = [];
  final List<AppException> _errorHistory = [];
  static const int _maxHistorySize = 100;

  /// Registers an error reporter callback.
  void registerReporter(ErrorReportCallback reporter) {
    _reporters.add(reporter);
  }

  /// Unregisters an error reporter callback.
  void unregisterReporter(ErrorReportCallback reporter) {
    _reporters.remove(reporter);
  }

  /// Handles an error by logging and notifying reporters.
  void handleError(
    Object error, {
    required String operation,
    StackTrace? stackTrace,
    Map<String, dynamic>? details,
  }) {
    final context = ErrorContext(
      operation: operation,
      details: details ?? {},
      timestamp: DateTime.now(),
    );

    // Log the error
    _logError(error, stackTrace, context);

    // Add to history
    _addToHistory(error, context);

    // Notify reporters
    for (final reporter in _reporters) {
      try {
        reporter(error, stackTrace, context);
      } catch (e) {
        // Ignore errors in error reporters to prevent infinite loops
        debugPrint('Error in error reporter: $e');
      }
    }
  }

  /// Wraps a synchronous operation with error handling.
  T runGuarded<T>(
    T Function() operation, {
    required String operationName,
    T Function(Object error, StackTrace? stackTrace)? onError,
  }) {
    try {
      return operation();
    } catch (error, stackTrace) {
      handleError(
        error,
        stackTrace: stackTrace,
        operation: operationName,
      );
      if (onError != null) {
        return onError(error, stackTrace);
      }
      rethrow;
    }
  }

  /// Wraps an asynchronous operation with error handling.
  Future<T> runGuardedAsync<T>(
    Future<T> Function() operation, {
    required String operationName,
    FutureOr<T> Function(Object error, StackTrace? stackTrace)? onError,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      handleError(
        error,
        stackTrace: stackTrace,
        operation: operationName,
      );
      if (onError != null) {
        return await onError(error, stackTrace);
      }
      rethrow;
    }
  }

  /// Gets the recent error history.
  List<AppException> get errorHistory => List.unmodifiable(_errorHistory);

  /// Clears the error history.
  void clearHistory() {
    _errorHistory.clear();
  }

  void _logError(Object error, StackTrace? stackTrace, ErrorContext context) {
    final message = StringBuffer()
      ..writeln('=== ERROR ===')
      ..writeln('Operation: ${context.operation}')
      ..writeln('Time: ${context.timestamp}')
      ..writeln('Error: $error');

    if (context.details.isNotEmpty) {
      message.writeln('Details: ${context.details}');
    }

    if (stackTrace != null) {
      message
        ..writeln('Stack trace:')
        ..writeln(stackTrace);
    }

    message.writeln('=============');

    debugPrint(message.toString());
  }

  void _addToHistory(Object error, ErrorContext context) {
    final appException = error is AppException
        ? error
        : AppException.unknown(
            error.toString(),
            originalError: error,
          );

    _errorHistory.add(appException);

    // Trim history if too large
    while (_errorHistory.length > _maxHistorySize) {
      _errorHistory.removeAt(0);
    }
  }
}

/// Extension to convert common errors to AppException.
extension ErrorToAppException on Object {
  /// Converts this error to an AppException.
  AppException toAppException() {
    if (this is AppException) {
      return this as AppException;
    }
    return AppException.unknown(
      toString(),
      originalError: this,
    );
  }
}

/// Utility for creating user-friendly error messages.
class ErrorMessages {
  const ErrorMessages._();

  /// Gets a user-friendly message for file operation errors.
  static String forFileOperation(String operation, String? path) {
    switch (operation) {
      case 'open':
        return 'Could not open the file. Please check the file exists and '
            'you have permission to access it.';
      case 'save':
        return 'Could not save the file. Please check you have permission '
            'to write to this location.';
      case 'read':
        return 'Could not read the file. The file may be corrupted or '
            'in an unsupported format.';
      default:
        return 'A file operation failed. Please try again.';
    }
  }

  /// Gets a user-friendly message for project errors.
  static String forProject(String operation) {
    switch (operation) {
      case 'create':
        return 'Could not create a new project. Please try again.';
      case 'load':
        return 'Could not load the project. The file may be corrupted or '
            'created with a newer version.';
      case 'save':
        return 'Could not save the project. Please check you have permission '
            'to write to this location.';
      default:
        return 'A project operation failed. Please try again.';
    }
  }

  /// Gets a user-friendly message for code generation errors.
  static String forCodeGeneration(String? widget) {
    if (widget != null) {
      return 'Could not generate code for $widget. '
          'Some properties may not be supported.';
    }
    return 'Could not generate code. Please check your widget configuration.';
  }

  /// Gets a recovery suggestion for an error.
  static String? getRecoverySuggestion(Object error) {
    if (error is AppException) {
      return error.map(
        validation: (_) => 'Please check your input and try again.',
        notFound: (_) => 'Make sure the file or resource exists.',
        permission: (_) => 'Grant the necessary permissions and try again.',
        format: (_) =>
            'The file format is not supported. Try a different file.',
        io: (_) => 'Check your disk space and file permissions.',
        state: (_) => 'Try restarting the application.',
        unknown: (_) => 'If the problem persists, please contact support.',
      );
    }
    return 'If the problem persists, please contact support.';
  }
}
