import 'dart:async';
import 'dart:convert';

import 'package:flutter_forge/core/models/forge_project.dart';

/// Recovery data containing project and metadata.
class RecoveryData {
  /// Creates recovery data.
  const RecoveryData({
    required this.project,
    required this.timestamp,
    this.originalPath,
  });

  /// Creates recovery data from JSON.
  factory RecoveryData.fromJson(Map<String, dynamic> json) => RecoveryData(
        project: ForgeProject.fromJson(json['project'] as Map<String, dynamic>),
        timestamp: DateTime.parse(json['timestamp'] as String),
        originalPath: json['originalPath'] as String?,
      );

  /// The recovered project.
  final ForgeProject project;

  /// When the recovery data was saved.
  final DateTime timestamp;

  /// Original file path if the project was saved.
  final String? originalPath;

  Map<String, dynamic> toJson() => {
        'project': project.toJson(),
        'timestamp': timestamp.toIso8601String(),
        'originalPath': originalPath,
      };
}

/// Abstract storage interface for auto-save data.
abstract class AutoSaveStorage {
  Future<void> save(RecoveryData data);
  Future<RecoveryData?> load();
  Future<void> clear();
  Future<bool> hasRecoveryData();
}

/// In-memory storage for testing.
class InMemoryAutoSaveStorage implements AutoSaveStorage {
  String? _data;

  bool get hasData => _data != null;

  @override
  Future<void> save(RecoveryData data) async {
    _data = jsonEncode(data.toJson());
  }

  @override
  Future<RecoveryData?> load() async {
    if (_data == null) return null;
    try {
      final json = jsonDecode(_data!) as Map<String, dynamic>;
      return RecoveryData.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clear() async {
    _data = null;
  }

  @override
  Future<bool> hasRecoveryData() async => _data != null;
}

/// Service for auto-saving and crash recovery.
class AutoSaveService {
  AutoSaveService({
    required this.storage,
    this.autoSaveInterval = const Duration(seconds: 60),
  });

  /// Default auto-save interval.
  static const defaultInterval = Duration(seconds: 60);

  final AutoSaveStorage storage;
  final Duration autoSaveInterval;

  Timer? _timer;
  bool _enabled = true;
  ForgeProject? _currentProject;
  String? _currentPath;

  /// Whether auto-save is enabled.
  bool get isEnabled => _enabled;

  /// Enables auto-save.
  void enable() {
    _enabled = true;
  }

  /// Disables auto-save.
  void disable() {
    _enabled = false;
    _timer?.cancel();
    _timer = null;
  }

  /// Starts auto-save timer for the given project.
  void startAutoSave(ForgeProject project, {String? filePath}) {
    _currentProject = project;
    _currentPath = filePath;

    _timer?.cancel();
    if (_enabled) {
      _timer = Timer.periodic(autoSaveInterval, (_) => _autoSave());
    }
  }

  /// Stops auto-save timer.
  void stopAutoSave() {
    _timer?.cancel();
    _timer = null;
    _currentProject = null;
    _currentPath = null;
  }

  Future<void> _autoSave() async {
    if (!_enabled || _currentProject == null) return;
    await saveRecoveryData(_currentProject!, originalPath: _currentPath);
  }

  /// Saves recovery data.
  Future<void> saveRecoveryData(
    ForgeProject project, {
    String? originalPath,
  }) async {
    final data = RecoveryData(
      project: project,
      timestamp: DateTime.now(),
      originalPath: originalPath,
    );
    await storage.save(data);
  }

  /// Loads recovery data if available.
  Future<RecoveryData?> loadRecoveryData() async {
    return storage.load();
  }

  /// Clears recovery data.
  Future<void> clearRecoveryData() async {
    await storage.clear();
  }

  /// Checks if recovery data exists.
  Future<bool> hasRecoveryData() async {
    return storage.hasRecoveryData();
  }

  /// Disposes the service.
  void dispose() {
    _timer?.cancel();
  }
}
