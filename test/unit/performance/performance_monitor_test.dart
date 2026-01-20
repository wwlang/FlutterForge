import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/core/performance/performance_monitor.dart';

void main() {
  group('Performance Optimization (Task 5.2)', () {
    late PerformanceMonitor monitor;

    setUp(() {
      monitor = PerformanceMonitor.instance;
      monitor.clear();
    });

    tearDown(() {
      monitor.clear();
    });

    group('PerformanceMonitor', () {
      test('startMeasurement and endMeasurement records duration', () async {
        monitor.startMeasurement('test-op');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        final duration = monitor.endMeasurement('test-op');

        expect(duration, isNotNull);
        expect(duration!.inMilliseconds, greaterThanOrEqualTo(10));
      });

      test('endMeasurement returns null for unknown timer', () {
        final duration = monitor.endMeasurement('unknown');
        expect(duration, isNull);
      });

      test('measure wraps synchronous function', () {
        var called = false;
        final result = monitor.measure<int>('sync-op', () {
          called = true;
          return 42;
        });

        expect(result, equals(42));
        expect(called, isTrue);
        expect(monitor.getMeasurements('sync-op'), hasLength(1));
      });

      test('measureAsync wraps asynchronous function', () async {
        var called = false;
        final result = await monitor.measureAsync<int>('async-op', () async {
          called = true;
          await Future<void>.delayed(const Duration(milliseconds: 5));
          return 42;
        });

        expect(result, equals(42));
        expect(called, isTrue);
        expect(monitor.getMeasurements('async-op'), hasLength(1));
        expect(
          monitor.getMeasurements('async-op').first.inMilliseconds,
          greaterThanOrEqualTo(5),
        );
      });

      test('getMeasurements returns empty list for unknown name', () {
        expect(monitor.getMeasurements('unknown'), isEmpty);
      });

      test('getMeasurements returns unmodifiable list', () {
        monitor.measure('test', () {});
        final measurements = monitor.getMeasurements('test');
        expect(() => measurements.add(Duration.zero), throwsUnsupportedError);
      });

      test('getAverageDuration calculates correctly', () {
        // Record multiple measurements
        for (var i = 0; i < 3; i++) {
          monitor.startMeasurement('avg-test');
          monitor.endMeasurement('avg-test');
        }

        final avg = monitor.getAverageDuration('avg-test');
        expect(avg, isNotNull);
        expect(avg!.inMicroseconds, greaterThanOrEqualTo(0));
      });

      test('getAverageDuration returns null for unknown name', () {
        expect(monitor.getAverageDuration('unknown'), isNull);
      });

      test('getMinDuration returns minimum', () async {
        // Short operation
        monitor.startMeasurement('min-test');
        monitor.endMeasurement('min-test');

        // Longer operation
        monitor.startMeasurement('min-test');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        monitor.endMeasurement('min-test');

        final min = monitor.getMinDuration('min-test');
        expect(min, isNotNull);
        expect(min!.inMilliseconds, lessThan(10));
      });

      test('getMaxDuration returns maximum', () async {
        // Short operation
        monitor.startMeasurement('max-test');
        monitor.endMeasurement('max-test');

        // Longer operation
        monitor.startMeasurement('max-test');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        monitor.endMeasurement('max-test');

        final max = monitor.getMaxDuration('max-test');
        expect(max, isNotNull);
        expect(max!.inMilliseconds, greaterThanOrEqualTo(10));
      });

      test('measurementNames returns all recorded names', () {
        monitor.measure('op1', () {});
        monitor.measure('op2', () {});
        monitor.measure('op3', () {});

        final names = monitor.measurementNames;
        expect(names, containsAll(['op1', 'op2', 'op3']));
      });

      test('clear removes all measurements', () {
        monitor.measure('test1', () {});
        monitor.measure('test2', () {});

        monitor.clear();

        expect(monitor.measurementNames, isEmpty);
        expect(monitor.getMeasurements('test1'), isEmpty);
      });

      test('clearMeasurement removes specific measurement', () {
        monitor.measure('keep', () {});
        monitor.measure('remove', () {});

        monitor.clearMeasurement('remove');

        expect(monitor.getMeasurements('keep'), hasLength(1));
        expect(monitor.getMeasurements('remove'), isEmpty);
      });

      test('getSummary returns metrics for all measurements', () {
        monitor.measure('op1', () {});
        monitor.measure('op2', () {});

        final summary = monitor.getSummary();

        expect(summary, hasLength(2));
        expect(summary.containsKey('op1'), isTrue);
        expect(summary.containsKey('op2'), isTrue);
      });
    });

    group('PerformanceMetrics', () {
      test('fromDurations calculates correct metrics', () {
        final durations = [
          const Duration(milliseconds: 10),
          const Duration(milliseconds: 20),
          const Duration(milliseconds: 30),
        ];

        final metrics = PerformanceMetrics.fromDurations(durations);

        expect(metrics.count, equals(3));
        expect(metrics.min.inMilliseconds, equals(10));
        expect(metrics.max.inMilliseconds, equals(30));
        expect(metrics.average.inMilliseconds, equals(20));
        expect(metrics.total.inMilliseconds, equals(60));
      });

      test('fromDurations handles empty list', () {
        final metrics = PerformanceMetrics.fromDurations([]);

        expect(metrics.count, equals(0));
        expect(metrics.min, equals(Duration.zero));
        expect(metrics.max, equals(Duration.zero));
        expect(metrics.average, equals(Duration.zero));
        expect(metrics.total, equals(Duration.zero));
      });

      test('toString provides readable output', () {
        final metrics = PerformanceMetrics.fromDurations([
          const Duration(milliseconds: 100),
        ]);

        final str = metrics.toString();
        expect(str, contains('count: 1'));
        expect(str, contains('avg: 100ms'));
      });
    });

    group('PerformanceThresholds', () {
      test('maxProjectLoadTime is 2 seconds', () {
        expect(
          PerformanceThresholds.maxProjectLoadTime.inSeconds,
          equals(2),
        );
      });

      test('maxProjectSaveTime is 500ms', () {
        expect(
          PerformanceThresholds.maxProjectSaveTime.inMilliseconds,
          equals(500),
        );
      });

      test('maxCodeGenerationTime is 200ms', () {
        expect(
          PerformanceThresholds.maxCodeGenerationTime.inMilliseconds,
          equals(200),
        );
      });

      test('maxWidgetTreeUpdateTime is 50ms', () {
        expect(
          PerformanceThresholds.maxWidgetTreeUpdateTime.inMilliseconds,
          equals(50),
        );
      });

      test('maxCanvasRenderTime is 16ms (60 FPS)', () {
        expect(
          PerformanceThresholds.maxCanvasRenderTime.inMilliseconds,
          equals(16),
        );
      });

      test('targetFrameTime is 16ms', () {
        expect(
          PerformanceThresholds.targetFrameTime.inMilliseconds,
          equals(16),
        );
      });

      test('maxMemoryUsageMB is 500', () {
        expect(PerformanceThresholds.maxMemoryUsageMB, equals(500));
      });

      test('isWithinThreshold returns true for duration under threshold', () {
        const duration = Duration(milliseconds: 100);
        const threshold = Duration(milliseconds: 500);
        expect(
          PerformanceThresholds.isWithinThreshold(duration, threshold),
          isTrue,
        );
      });

      test('isWithinThreshold returns false for duration over threshold', () {
        const duration = Duration(milliseconds: 600);
        const threshold = Duration(milliseconds: 500);
        expect(
          PerformanceThresholds.isWithinThreshold(duration, threshold),
          isFalse,
        );
      });

      test('isWithinThreshold returns true for equal duration', () {
        const duration = Duration(milliseconds: 500);
        const threshold = Duration(milliseconds: 500);
        expect(
          PerformanceThresholds.isWithinThreshold(duration, threshold),
          isTrue,
        );
      });
    });
  });
}
