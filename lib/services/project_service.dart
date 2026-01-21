import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/features/assets/asset_manager.dart';
import 'package:uuid/uuid.dart';

/// Exception thrown when .forge file operations fail.
class ForgeFileException implements Exception {
  /// Creates a new ForgeFileException.
  const ForgeFileException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => 'ForgeFileException: $message';
}

/// Service for project file operations.
///
/// Handles creating, saving, and loading FlutterForge projects
/// in the .forge file format.
class ProjectService {
  static const _uuid = Uuid();

  /// Current format version for .forge files.
  static const formatVersion = '1.0';

  /// Application version (should match pubspec).
  static const appVersion = '0.1.0';

  /// Creates a new project with default values.
  ///
  /// If [withDefaultScreen] is true, creates an initial empty screen.
  ForgeProject createNewProject({
    required String name,
    bool withDefaultScreen = false,
  }) {
    final now = DateTime.now();
    final projectId = _uuid.v4();

    final screens = <ScreenDefinition>[];
    if (withDefaultScreen) {
      screens.add(
        ScreenDefinition(
          id: _uuid.v4(),
          name: 'Screen 1',
          rootNodeId: '',
          nodes: const {},
        ),
      );
    }

    return ForgeProject(
      id: projectId,
      name: name,
      screens: screens,
      metadata: ProjectMetadata(
        createdAt: now,
        modifiedAt: now,
        forgeVersion: appVersion,
      ),
    );
  }

  /// Serializes a project to .forge file format (ZIP archive).
  ///
  /// The archive contains:
  /// - manifest.json: Version info and compatibility data
  /// - project.json: Full project serialization
  /// - assets/: Directory for embedded assets (future)
  Future<Uint8List> serializeToForgeFormat(ForgeProject project) async {
    final archive = Archive()
      ..addFile(
        ArchiveFile(
          'manifest.json',
          0,
          utf8.encode(
            const JsonEncoder.withIndent('  ').convert({
              'formatVersion': formatVersion,
              'appVersion': appVersion,
              'projectId': project.id,
              'createdWith': 'FlutterForge',
              'timestamp': DateTime.now().toIso8601String(),
            }),
          ),
        ),
      )
      ..addFile(
        ArchiveFile(
          'project.json',
          0,
          utf8.encode(
            const JsonEncoder.withIndent('  ').convert(project.toJson()),
          ),
        ),
      )
      ..addFile(
        ArchiveFile(
          'assets/.gitkeep',
          0,
          utf8.encode(''),
        ),
      );

    // Encode to ZIP
    final zipBytes = ZipEncoder().encode(archive);
    return Uint8List.fromList(zipBytes);
  }

  /// Serializes a project with assets to .forge file format (ZIP archive).
  ///
  /// The archive contains:
  /// - manifest.json: Version info, compatibility data, and asset manifest
  /// - project.json: Full project serialization
  /// - assets/: Directory containing all project assets
  Future<Uint8List> serializeWithAssets({
    required ForgeProject project,
    required AssetManager assetManager,
  }) async {
    // Build asset manifest
    final assetManifest = <Map<String, dynamic>>[];
    for (final asset in assetManager.assets) {
      assetManifest.add({
        'id': asset.id,
        'fileName': asset.fileName,
        'assetPath': asset.assetPath,
      });
    }

    // Build archive with cascades
    final archive = Archive()
      ..addFile(
        ArchiveFile(
          'manifest.json',
          0,
          utf8.encode(
            const JsonEncoder.withIndent('  ').convert({
              'formatVersion': formatVersion,
              'appVersion': appVersion,
              'projectId': project.id,
              'createdWith': 'FlutterForge',
              'timestamp': DateTime.now().toIso8601String(),
              'assets': assetManifest,
            }),
          ),
        ),
      )
      ..addFile(
        ArchiveFile(
          'project.json',
          0,
          utf8.encode(
            const JsonEncoder.withIndent('  ').convert(project.toJson()),
          ),
        ),
      )
      ..addFile(
        ArchiveFile('assets/', 0, <int>[]),
      );

    // Add each asset file
    for (final asset in assetManager.assets) {
      // Use the asset path (e.g., 'assets/logo.png') as the archive path
      archive.addFile(
        ArchiveFile(
          asset.assetPath,
          asset.bytes.length,
          asset.bytes,
        ),
      );
    }

    // Encode to ZIP
    final zipBytes = ZipEncoder().encode(archive);
    return Uint8List.fromList(zipBytes);
  }

  /// Deserializes a project from .forge file bytes.
  ///
  /// Throws [ForgeFileException] if the file is invalid or corrupted.
  Future<ForgeProject> deserializeFromForgeFormat(Uint8List bytes) async {
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (e) {
      throw const ForgeFileException(
        'Invalid .forge file: not a valid ZIP archive',
      );
    }

    // Find and validate manifest
    ArchiveFile? manifestFile;
    ArchiveFile? projectFile;

    for (final file in archive.files) {
      if (file.name == 'manifest.json') {
        manifestFile = file;
      } else if (file.name == 'project.json') {
        projectFile = file;
      }
    }

    if (manifestFile == null) {
      throw const ForgeFileException(
        'Invalid .forge file: missing manifest.json',
      );
    }

    if (projectFile == null) {
      throw const ForgeFileException(
        'Invalid .forge file: missing project.json',
      );
    }

    // Parse manifest to check version
    try {
      final manifestContent = utf8.decode(manifestFile.content as List<int>);
      final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;
      final fileFormatVersion = manifest['formatVersion'] as String?;

      if (fileFormatVersion == null) {
        throw const ForgeFileException(
          'Invalid .forge file: manifest missing formatVersion',
        );
      }

      // Check version compatibility (for future migrations)
      if (!_isVersionCompatible(fileFormatVersion)) {
        throw ForgeFileException(
          'Incompatible .forge file version: $fileFormatVersion '
          '(current: $formatVersion)',
        );
      }
    } catch (e) {
      if (e is ForgeFileException) rethrow;
      throw const ForgeFileException(
        'Invalid .forge file: corrupt manifest.json',
      );
    }

    // Parse project
    try {
      final projectContent = utf8.decode(projectFile.content as List<int>);
      final projectJson = jsonDecode(projectContent) as Map<String, dynamic>;
      return ForgeProject.fromJson(projectJson);
    } catch (e) {
      if (e is ForgeFileException) rethrow;
      throw ForgeFileException(
        'Invalid .forge file: corrupt project.json - $e',
      );
    }
  }

  /// Deserializes a project and its assets from .forge file bytes.
  ///
  /// Assets are restored to the provided [assetManager].
  /// Returns the deserialized [ForgeProject].
  ///
  /// Throws [ForgeFileException] if the file is invalid or corrupted.
  Future<ForgeProject> deserializeWithAssets({
    required Uint8List bytes,
    required AssetManager assetManager,
  }) async {
    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes);
    } catch (e) {
      throw const ForgeFileException(
        'Invalid .forge file: not a valid ZIP archive',
      );
    }

    // Find files
    ArchiveFile? manifestFile;
    ArchiveFile? projectFile;
    final assetFiles = <String, ArchiveFile>{};

    for (final file in archive.files) {
      if (file.name == 'manifest.json') {
        manifestFile = file;
      } else if (file.name == 'project.json') {
        projectFile = file;
      } else if (file.name.startsWith('assets/') && file.isFile) {
        assetFiles[file.name] = file;
      }
    }

    if (manifestFile == null) {
      throw const ForgeFileException(
        'Invalid .forge file: missing manifest.json',
      );
    }

    if (projectFile == null) {
      throw const ForgeFileException(
        'Invalid .forge file: missing project.json',
      );
    }

    // Parse manifest
    var assetManifest = <Map<String, dynamic>>[];
    try {
      final manifestContent = utf8.decode(manifestFile.content as List<int>);
      final manifest = jsonDecode(manifestContent) as Map<String, dynamic>;
      final fileFormatVersion = manifest['formatVersion'] as String?;

      if (fileFormatVersion == null) {
        throw const ForgeFileException(
          'Invalid .forge file: manifest missing formatVersion',
        );
      }

      if (!_isVersionCompatible(fileFormatVersion)) {
        throw ForgeFileException(
          'Incompatible .forge file version: $fileFormatVersion '
          '(current: $formatVersion)',
        );
      }

      // Extract asset manifest (may not exist in older formats)
      if (manifest['assets'] != null) {
        assetManifest =
            (manifest['assets'] as List).cast<Map<String, dynamic>>();
      }
    } catch (e) {
      if (e is ForgeFileException) rethrow;
      throw const ForgeFileException(
        'Invalid .forge file: corrupt manifest.json',
      );
    }

    // Restore assets
    for (final assetInfo in assetManifest) {
      final assetPath = assetInfo['assetPath'] as String;
      final assetFile = assetFiles[assetPath];

      if (assetFile != null) {
        // Restore the asset with its original metadata
        _restoreAsset(
          assetManager: assetManager,
          id: assetInfo['id'] as String,
          fileName: assetInfo['fileName'] as String,
          assetPath: assetPath,
          bytes: Uint8List.fromList(assetFile.content as List<int>),
        );
      }
    }

    // Parse project
    try {
      final projectContent = utf8.decode(projectFile.content as List<int>);
      final projectJson = jsonDecode(projectContent) as Map<String, dynamic>;
      return ForgeProject.fromJson(projectJson);
    } catch (e) {
      if (e is ForgeFileException) rethrow;
      throw ForgeFileException(
        'Invalid .forge file: corrupt project.json - $e',
      );
    }
  }

  /// Restores an asset to the asset manager with specific metadata.
  void _restoreAsset({
    required AssetManager assetManager,
    required String id,
    required String fileName,
    required String assetPath,
    required Uint8List bytes,
  }) {
    // Create the asset directly with the restored metadata
    final asset = ProjectAsset(
      id: id,
      fileName: fileName,
      assetPath: assetPath,
      bytes: bytes,
    );

    // Use internal method to add the asset
    assetManager.restoreAsset(asset);
  }

  /// Checks if a format version is compatible with current version.
  bool _isVersionCompatible(String fileVersion) {
    // For now, only support exact match
    // In future, implement migration logic for older versions
    final fileMajor = int.tryParse(fileVersion.split('.').first) ?? 0;
    final currentMajor = int.tryParse(formatVersion.split('.').first) ?? 0;

    // Same major version is compatible
    return fileMajor == currentMajor;
  }

  /// Updates project modified timestamp.
  ForgeProject updateModifiedTime(ForgeProject project) {
    return project.copyWith(
      metadata: project.metadata.copyWith(
        modifiedAt: DateTime.now(),
      ),
    );
  }
}
