import 'dart:async';

/// Performance monitoring and metrics collection.
///
/// Provides tools for measuring and optimizing application performance.
class PerformanceMonitor {
  PerformanceMonitor._();

  static final _instance = PerformanceMonitor._();

  /// Singleton instance.
  static PerformanceMonitor get instance => _instance;

  final Map<String, List<Duration>> _measurements = {};
  final Map<String, Stopwatch> _activeTimers = {};

  /// Starts a performance measurement.
  void startMeasurement(String name) {
    _activeTimers[name] = Stopwatch()..start();
  }

  /// Ends a performance measurement and records the duration.
  Duration? endMeasurement(String name) {
    final stopwatch = _activeTimers.remove(name);
    if (stopwatch == null) return null;

    stopwatch.stop();
    final duration = stopwatch.elapsed;

    _measurements.putIfAbsent(name, () => []).add(duration);
    return duration;
  }

  /// Measures the execution time of a synchronous function.
  T measure<T>(String name, T Function() fn) {
    startMeasurement(name);
    try {
      return fn();
    } finally {
      endMeasurement(name);
    }
  }

  /// Measures the execution time of an asynchronous function.
  Future<T> measureAsync<T>(String name, Future<T> Function() fn) async {
    startMeasurement(name);
    try {
      return await fn();
    } finally {
      endMeasurement(name);
    }
  }

  /// Gets all recorded measurements for a given name.
  List<Duration> getMeasurements(String name) =>
      List.unmodifiable(_measurements[name] ?? []);

  /// Gets the average duration for a measurement.
  Duration? getAverageDuration(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) return null;

    final totalMicroseconds = measurements.fold<int>(
      0,
      (sum, d) => sum + d.inMicroseconds,
    );
    return Duration(microseconds: totalMicroseconds ~/ measurements.length);
  }

  /// Gets the minimum duration for a measurement.
  Duration? getMinDuration(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) return null;

    return measurements.reduce(
      (a, b) => a.inMicroseconds < b.inMicroseconds ? a : b,
    );
  }

  /// Gets the maximum duration for a measurement.
  Duration? getMaxDuration(String name) {
    final measurements = _measurements[name];
    if (measurements == null || measurements.isEmpty) return null;

    return measurements.reduce(
      (a, b) => a.inMicroseconds > b.inMicroseconds ? a : b,
    );
  }

  /// Gets all measurement names.
  Set<String> get measurementNames => _measurements.keys.toSet();

  /// Clears all measurements.
  void clear() {
    _measurements.clear();
    _activeTimers.clear();
  }

  /// Clears measurements for a specific name.
  void clearMeasurement(String name) {
    _measurements.remove(name);
    _activeTimers.remove(name);
  }

  /// Gets a summary of all measurements.
  Map<String, PerformanceMetrics> getSummary() {
    return _measurements.map(
      (name, durations) =>
          MapEntry(name, PerformanceMetrics.fromDurations(durations)),
    );
  }
}

/// Summary metrics for a set of performance measurements.
class PerformanceMetrics {
  const PerformanceMetrics({
    required this.count,
    required this.average,
    required this.min,
    required this.max,
    required this.total,
  });

  /// Creates metrics from a list of durations.
  factory PerformanceMetrics.fromDurations(List<Duration> durations) {
    if (durations.isEmpty) {
      return const PerformanceMetrics(
        count: 0,
        average: Duration.zero,
        min: Duration.zero,
        max: Duration.zero,
        total: Duration.zero,
      );
    }

    final totalMicroseconds = durations.fold<int>(
      0,
      (sum, d) => sum + d.inMicroseconds,
    );

    final min = durations.reduce(
      (a, b) => a.inMicroseconds < b.inMicroseconds ? a : b,
    );

    final max = durations.reduce(
      (a, b) => a.inMicroseconds > b.inMicroseconds ? a : b,
    );

    return PerformanceMetrics(
      count: durations.length,
      average: Duration(microseconds: totalMicroseconds ~/ durations.length),
      min: min,
      max: max,
      total: Duration(microseconds: totalMicroseconds),
    );
  }

  /// Number of measurements.
  final int count;

  /// Average duration.
  final Duration average;

  /// Minimum duration.
  final Duration min;

  /// Maximum duration.
  final Duration max;

  /// Total duration.
  final Duration total;

  @override
  String toString() {
    return 'PerformanceMetrics(count: $count, avg: ${average.inMilliseconds}ms, '
        'min: ${min.inMilliseconds}ms, max: ${max.inMilliseconds}ms)';
  }
}

/// Performance thresholds for validation.
class PerformanceThresholds {
  const PerformanceThresholds._();

  /// Maximum acceptable project load time.
  static const Duration maxProjectLoadTime = Duration(seconds: 2);

  /// Maximum acceptable project save time.
  static const Duration maxProjectSaveTime = Duration(milliseconds: 500);

  /// Maximum acceptable code generation time.
  static const Duration maxCodeGenerationTime = Duration(milliseconds: 200);

  /// Maximum acceptable widget tree update time.
  static const Duration maxWidgetTreeUpdateTime = Duration(milliseconds: 50);

  /// Maximum acceptable canvas render time.
  static const Duration maxCanvasRenderTime = Duration(milliseconds: 16);

  /// Target frame time (60 FPS).
  static const Duration targetFrameTime = Duration(milliseconds: 16);

  /// Maximum memory usage for large projects (100+ widgets).
  static const int maxMemoryUsageMB = 500;

  /// Checks if a duration is within the acceptable threshold.
  static bool isWithinThreshold(Duration duration, Duration threshold) {
    return duration <= threshold;
  }
}
