import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// A project asset (image file) that has been imported.
class ProjectAsset {
  /// Creates a new project asset.
  const ProjectAsset({
    required this.id,
    required this.fileName,
    required this.assetPath,
    required this.bytes,
  });

  /// Creates a project asset from JSON data.
  factory ProjectAsset.fromJson(Map<String, dynamic> json) {
    return ProjectAsset(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      assetPath: json['assetPath'] as String,
      bytes: Uint8List.fromList(
        (json['bytes'] as List<dynamic>).cast<int>(),
      ),
    );
  }

  /// Unique identifier for this asset.
  final String id;

  /// Original file name.
  final String fileName;

  /// Path in the assets folder (e.g., 'assets/logo.png').
  final String assetPath;

  /// Raw bytes of the asset.
  final Uint8List bytes;

  /// File extension (lowercase, without dot).
  String get extension => fileName.split('.').last.toLowerCase();

  /// File size in bytes.
  int get sizeBytes => bytes.length;

  /// Converts this asset to JSON for serialization.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'assetPath': assetPath,
      'bytes': bytes.toList(),
    };
  }
}

/// Result of validating an asset's file size.
class SizeValidationResult {
  const SizeValidationResult._({
    required this.isValid,
    required this.requiresConfirmation,
    this.sizeBytes = 0,
    this.errorMessage,
  });

  /// Creates a valid result for files under the warning threshold.
  factory SizeValidationResult.valid({required int sizeBytes}) {
    return SizeValidationResult._(
      isValid: true,
      requiresConfirmation: false,
      sizeBytes: sizeBytes,
    );
  }

  /// Creates a result that requires user confirmation.
  factory SizeValidationResult.needsConfirmation({required int sizeBytes}) {
    return SizeValidationResult._(
      isValid: true,
      requiresConfirmation: true,
      sizeBytes: sizeBytes,
    );
  }

  /// Creates an invalid result for files that exceed the maximum size.
  factory SizeValidationResult.invalid({required String reason}) {
    return SizeValidationResult._(
      isValid: false,
      requiresConfirmation: false,
      errorMessage: reason,
    );
  }

  /// Whether the file can be imported.
  final bool isValid;

  /// Whether user confirmation is required before import.
  final bool requiresConfirmation;

  /// Size of the file in bytes.
  final int sizeBytes;

  /// Error message if the file is invalid.
  final String? errorMessage;

  /// Size of the file in megabytes.
  double get sizeInMB => sizeBytes / (1024 * 1024);
}

/// Manages project assets (images).
///
/// Handles validation, registration, and lookup of imported assets.
/// Assets are stored in memory and serialized with the project.
class AssetManager {
  /// Creates a new asset manager.
  AssetManager();

  static const _uuid = Uuid();

  /// Maximum file size (50MB) - files larger are rejected.
  static const int maxFileSizeBytes = 50 * 1024 * 1024;

  /// Warning threshold (10MB) - files larger require confirmation.
  static const int warnFileSizeBytes = 10 * 1024 * 1024;

  /// Supported image file extensions.
  static const supportedExtensions = {
    'png',
    'jpg',
    'jpeg',
    'webp',
    'gif',
    'svg',
  };

  /// Pattern for valid filename characters.
  static final _validCharsPattern = RegExp('[^a-z0-9_-]');

  final List<ProjectAsset> _assets = [];
  final Map<String, ProjectAsset> _byId = {};
  final Map<String, ProjectAsset> _byPath = {};
  final Set<String> _usedPaths = {};

  /// All registered assets.
  List<ProjectAsset> get assets => List.unmodifiable(_assets);

  /// Creates an AssetManager from exported asset data.
  static AssetManager fromExported(List<Map<String, dynamic>> data) {
    final manager = AssetManager();
    for (final json in data) {
      final asset = ProjectAsset.fromJson(json);
      manager._addAsset(asset);
    }
    return manager;
  }

  /// Checks if a file name has a supported extension.
  bool isSupported(String fileName) {
    final dotIndex = fileName.lastIndexOf('.');
    if (dotIndex == -1) return false;

    final extension = fileName.substring(dotIndex + 1).toLowerCase();
    return supportedExtensions.contains(extension);
  }

  /// Validates file size and returns result.
  SizeValidationResult validateSize(Uint8List bytes) {
    if (bytes.length > maxFileSizeBytes) {
      return SizeValidationResult.invalid(
        reason: 'File exceeds 50MB limit',
      );
    }

    if (bytes.length > warnFileSizeBytes) {
      return SizeValidationResult.needsConfirmation(sizeBytes: bytes.length);
    }

    return SizeValidationResult.valid(sizeBytes: bytes.length);
  }

  /// Registers a new asset and returns it.
  ProjectAsset registerAsset({
    required String fileName,
    required Uint8List bytes,
  }) {
    final id = _uuid.v4();
    final assetPath = _generateUniquePath(fileName);

    final asset = ProjectAsset(
      id: id,
      fileName: fileName,
      assetPath: assetPath,
      bytes: bytes,
    );

    _addAsset(asset);
    return asset;
  }

  void _addAsset(ProjectAsset asset) {
    _assets.add(asset);
    _byId[asset.id] = asset;
    _byPath[asset.assetPath] = asset;
    _usedPaths.add(asset.assetPath);
  }

  String _generateUniquePath(String fileName) {
    // Extract extension
    final dotIndex = fileName.lastIndexOf('.');
    final extension = dotIndex != -1 ? fileName.substring(dotIndex) : '';
    final baseName =
        dotIndex != -1 ? fileName.substring(0, dotIndex) : fileName;

    // Clean up base name (replace spaces, special chars)
    final cleanBase =
        baseName.toLowerCase().replaceAll(_validCharsPattern, '_');

    // Generate path, ensuring uniqueness
    var path = 'assets/$cleanBase$extension';
    var counter = 1;

    while (_usedPaths.contains(path)) {
      path = 'assets/${cleanBase}_$counter$extension';
      counter++;
    }

    return path;
  }

  /// Gets an asset by its ID.
  ProjectAsset? getAsset(String id) => _byId[id];

  /// Gets an asset by its path.
  ProjectAsset? getAssetByPath(String path) => _byPath[path];

  /// Removes an asset from the registry.
  bool removeAsset(String id) {
    final asset = _byId[id];
    if (asset == null) return false;

    _assets.remove(asset);
    _byId.remove(id);
    _byPath.remove(asset.assetPath);
    _usedPaths.remove(asset.assetPath);
    return true;
  }

  /// Exports all assets for serialization.
  List<Map<String, dynamic>> exportAssets() {
    return _assets.map((a) => a.toJson()).toList();
  }

  /// Clears all assets.
  void clear() {
    _assets.clear();
    _byId.clear();
    _byPath.clear();
    _usedPaths.clear();
  }
}

/// Provider for the asset manager.
final assetManagerProvider = Provider<AssetManager>((ref) {
  return AssetManager();
});

/// Provider for the list of assets.
final assetsProvider = Provider<List<ProjectAsset>>((ref) {
  return ref.watch(assetManagerProvider).assets;
});
