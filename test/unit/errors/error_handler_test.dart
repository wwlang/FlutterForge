import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/core/errors/app_exception.dart';
import 'package:flutter_forge/core/errors/error_handler.dart';

void main() {
  group('Error Handling and Recovery (Task 5.4)', () {
    late ErrorHandler handler;

    setUp(() {
      handler = ErrorHandler.instance;
      handler.clearHistory();
    });

    group('ErrorContext', () {
      test('creates context with required fields', () {
        final context = ErrorContext(operation: 'test-op');

        expect(context.operation, equals('test-op'));
        expect(context.details, isEmpty);
      });

      test('creates context with optional fields', () {
        final timestamp = DateTime.now();
        final context = ErrorContext(
          operation: 'test-op',
          details: {'key': 'value'},
          timestamp: timestamp,
        );

        expect(context.operation, equals('test-op'));
        expect(context.details, equals({'key': 'value'}));
        expect(context.timestamp, equals(timestamp));
      });

      test('copyWith creates new context', () {
        final context = ErrorContext(operation: 'original');
        final copied = context.copyWith(operation: 'updated');

        expect(copied.operation, equals('updated'));
        expect(context.operation, equals('original'));
      });

      test('toString includes all fields', () {
        final context = ErrorContext(
          operation: 'test-op',
          details: {'key': 'value'},
        );

        final str = context.toString();
        expect(str, contains('test-op'));
        expect(str, contains('key'));
      });
    });

    group('ErrorHandler', () {
      test('singleton instance is consistent', () {
        final instance1 = ErrorHandler.instance;
        final instance2 = ErrorHandler.instance;
        expect(identical(instance1, instance2), isTrue);
      });

      test('handleError adds to history', () {
        handler.handleError(
          'Test error',
          operation: 'test',
        );

        expect(handler.errorHistory, hasLength(1));
      });

      test('errorHistory is unmodifiable', () {
        handler.handleError(
          'Test error',
          operation: 'test',
        );

        final history = handler.errorHistory;
        expect(() => history.add(const AppException.unknown('test')),
            throwsUnsupportedError);
      });

      test('clearHistory removes all errors', () {
        handler.handleError('Error 1', operation: 'test');
        handler.handleError('Error 2', operation: 'test');

        handler.clearHistory();

        expect(handler.errorHistory, isEmpty);
      });

      test('registerReporter adds callback', () {
        var called = false;
        final reporter = (Object e, StackTrace? st, ErrorContext ctx) {
          called = true;
        };

        handler.registerReporter(reporter);
        handler.handleError('Test error', operation: 'test');

        expect(called, isTrue);

        handler.unregisterReporter(reporter);
      });

      test('unregisterReporter removes callback', () {
        var callCount = 0;
        final reporter = (Object e, StackTrace? st, ErrorContext ctx) {
          callCount++;
        };

        handler.registerReporter(reporter);
        handler.handleError('Error 1', operation: 'test');
        expect(callCount, equals(1));

        handler.unregisterReporter(reporter);
        handler.handleError('Error 2', operation: 'test');
        expect(callCount, equals(1));
      });

      test('runGuarded catches and handles errors', () {
        var handled = false;
        final reporter = (Object e, StackTrace? st, ErrorContext ctx) {
          handled = true;
        };
        handler.registerReporter(reporter);

        expect(
          () => handler.runGuarded(
            () => throw Exception('Test'),
            operationName: 'test',
          ),
          throwsException,
        );
        expect(handled, isTrue);

        handler.unregisterReporter(reporter);
      });

      test('runGuarded returns result on success', () {
        final result = handler.runGuarded(
          () => 42,
          operationName: 'test',
        );

        expect(result, equals(42));
      });

      test('runGuarded calls onError handler', () {
        final result = handler.runGuarded<int>(
          () => throw Exception('Test'),
          operationName: 'test',
          onError: (e, st) => -1,
        );

        expect(result, equals(-1));
      });

      test('runGuardedAsync catches and handles errors', () async {
        var handled = false;
        final reporter = (Object e, StackTrace? st, ErrorContext ctx) {
          handled = true;
        };
        handler.registerReporter(reporter);

        await expectLater(
          handler.runGuardedAsync(
            () async => throw Exception('Test'),
            operationName: 'test',
          ),
          throwsException,
        );
        expect(handled, isTrue);

        handler.unregisterReporter(reporter);
      });

      test('runGuardedAsync returns result on success', () async {
        final result = await handler.runGuardedAsync(
          () async => 42,
          operationName: 'test',
        );

        expect(result, equals(42));
      });

      test('runGuardedAsync calls onError handler', () async {
        final result = await handler.runGuardedAsync<int>(
          () async => throw Exception('Test'),
          operationName: 'test',
          onError: (e, st) async => -1,
        );

        expect(result, equals(-1));
      });
    });

    group('ErrorToAppException Extension', () {
      test('converts string to AppException', () {
        const error = 'Test error';
        final exception = error.toAppException();

        expect(exception, isA<UnknownException>());
      });

      test('returns AppException unchanged', () {
        const original = AppException.validation(['error']);
        final result = original.toAppException();

        expect(identical(original, result), isTrue);
      });

      test('converts Exception to AppException', () {
        final error = Exception('Test');
        final exception = error.toAppException();

        expect(exception, isA<UnknownException>());
      });
    });

    group('ErrorMessages', () {
      test('forFileOperation returns message for open', () {
        final msg = ErrorMessages.forFileOperation('open', '/test/path');
        expect(msg, contains('open'));
        expect(msg, contains('file'));
      });

      test('forFileOperation returns message for save', () {
        final msg = ErrorMessages.forFileOperation('save', '/test/path');
        expect(msg, contains('save'));
      });

      test('forFileOperation returns message for read', () {
        final msg = ErrorMessages.forFileOperation('read', '/test/path');
        expect(msg, contains('read'));
      });

      test('forFileOperation returns default for unknown', () {
        final msg = ErrorMessages.forFileOperation('unknown', null);
        expect(msg, isNotEmpty);
      });

      test('forProject returns message for create', () {
        final msg = ErrorMessages.forProject('create');
        expect(msg, contains('create'));
      });

      test('forProject returns message for load', () {
        final msg = ErrorMessages.forProject('load');
        expect(msg, contains('load'));
      });

      test('forCodeGeneration includes widget name when provided', () {
        final msg = ErrorMessages.forCodeGeneration('Container');
        expect(msg, contains('Container'));
      });

      test('forCodeGeneration works without widget name', () {
        final msg = ErrorMessages.forCodeGeneration(null);
        expect(msg, isNotEmpty);
      });

      test('getRecoverySuggestion returns suggestion for AppException', () {
        const error = AppException.validation(['error']);
        final suggestion = ErrorMessages.getRecoverySuggestion(error);
        expect(suggestion, isNotEmpty);
      });

      test('getRecoverySuggestion returns default for unknown error', () {
        final suggestion = ErrorMessages.getRecoverySuggestion(Exception());
        expect(suggestion, isNotEmpty);
      });
    });

    group('AppException', () {
      test('validation has correct fields', () {
        const exception = AppException.validation(['error1', 'error2']);

        expect(exception, isA<ValidationException>());
        expect((exception as ValidationException).errors, hasLength(2));
      });

      test('notFound has correct fields', () {
        const exception =
            AppException.notFound('Project', id: '123', path: '/test');

        expect(exception, isA<NotFoundException>());
        expect((exception as NotFoundException).resource, equals('Project'));
        expect(exception.id, equals('123'));
      });

      test('permission has correct fields', () {
        const exception = AppException.permission('write', resource: 'file');

        expect(exception, isA<PermissionException>());
        expect((exception as PermissionException).operation, equals('write'));
      });

      test('format has correct fields', () {
        const exception =
            AppException.format('Invalid JSON', expectedFormat: 'JSON');

        expect(exception, isA<FormatException>());
        expect((exception as FormatException).reason, contains('Invalid'));
      });

      test('io has correct fields', () {
        const exception = AppException.io('read', path: '/test');

        expect(exception, isA<IOAppException>());
        expect((exception as IOAppException).operation, equals('read'));
      });

      test('state has correct fields', () {
        const exception = AppException.state(
          'Invalid state',
          expectedState: 'open',
          actualState: 'closed',
        );

        expect(exception, isA<StateException>());
        expect((exception as StateException).message, contains('Invalid'));
      });

      test('unknown has correct fields', () {
        final exception = AppException.unknown(
          'Unknown error',
          originalError: Exception('original'),
        );

        expect(exception, isA<UnknownException>());
        expect((exception as UnknownException).originalError, isNotNull);
      });
    });

    group('AppExceptionX Extension', () {
      test('title returns correct value for each type', () {
        expect(
          const AppException.validation(['e']).title,
          equals('Validation Error'),
        );
        expect(
          const AppException.notFound('r').title,
          equals('Not Found'),
        );
        expect(
          const AppException.permission('p').title,
          equals('Permission Denied'),
        );
        expect(
          const AppException.format('f').title,
          equals('Invalid Format'),
        );
        expect(
          const AppException.io('i').title,
          equals('File Error'),
        );
        expect(
          const AppException.state('s').title,
          equals('Invalid State'),
        );
        expect(
          const AppException.unknown('u').title,
          equals('Error'),
        );
      });

      test('userMessage returns friendly message', () {
        const exception = AppException.notFound('Project');
        expect(exception.userMessage, contains('Project'));
      });

      test('isRecoverable returns correct value', () {
        expect(const AppException.validation(['e']).isRecoverable, isTrue);
        expect(const AppException.notFound('r').isRecoverable, isFalse);
        expect(const AppException.permission('p').isRecoverable, isTrue);
        expect(const AppException.format('f').isRecoverable, isFalse);
        expect(const AppException.io('i').isRecoverable, isTrue);
        expect(const AppException.state('s').isRecoverable, isTrue);
        expect(const AppException.unknown('u').isRecoverable, isFalse);
      });
    });
  });
}
