import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
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
