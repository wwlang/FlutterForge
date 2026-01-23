import 'package:flutter_forge/core/models/design_token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forge_project.freezed.dart';
part 'forge_project.g.dart';

/// Main project container for FlutterForge.
///
/// Holds all screens, design tokens, and project metadata.
/// Serialized to .forge bundle for persistence.
@Freezed(toJson: true, fromJson: true)
class ForgeProject with _$ForgeProject {
  const factory ForgeProject({
    /// Unique project identifier (UUID).
    required String id,

    /// User-provided project name.
    required String name,

    /// List of screen definitions in this project.
    required List<ScreenDefinition> screens,

    /// Project metadata (creation date, version, etc.).
    required ProjectMetadata metadata,

    /// Design tokens for theming (colors, typography, spacing).
    @Default(<DesignToken>[]) List<DesignToken> designTokens,
  }) = _ForgeProject;

  factory ForgeProject.fromJson(Map<String, dynamic> json) =>
      _$ForgeProjectFromJson(json);
}

/// A single screen in the project.
///
/// Each screen has its own widget tree and can generate
/// a separate Dart file.
@Freezed(toJson: true, fromJson: true)
class ScreenDefinition with _$ScreenDefinition {
  const factory ScreenDefinition({
    /// Unique screen identifier (UUID).
    required String id,

    /// Screen name used for generated class name.
    required String name,

    /// ID of the root widget node for this screen.
    required String rootNodeId,

    /// All widget nodes for this screen, keyed by ID.
    /// Normalized map for O(1) access.
    required Map<String, dynamic> nodes,
  }) = _ScreenDefinition;

  factory ScreenDefinition.fromJson(Map<String, dynamic> json) =>
      _$ScreenDefinitionFromJson(json);
}

/// Project metadata for versioning and tracking.
@Freezed(toJson: true, fromJson: true)
class ProjectMetadata with _$ProjectMetadata {
  const factory ProjectMetadata({
    /// Project creation timestamp.
    required DateTime createdAt,

    /// Last modification timestamp.
    required DateTime modifiedAt,

    /// FlutterForge version used to create/edit this project.
    required String forgeVersion,

    /// Optional project description.
    String? description,

    /// Target Flutter SDK version for generated code.
    @Default('3.19.0') String flutterSdkVersion,

    /// Target Dart version for code generation (J19 S3).
    ///
    /// Controls shorthand syntax usage:
    /// - 'dart39': No shorthand (legacy compatibility)
    /// - 'dart310': Dot shorthand enabled (default)
    @Default('dart310') String targetDartVersion,
  }) = _ProjectMetadata;

  factory ProjectMetadata.fromJson(Map<String, dynamic> json) =>
      _$ProjectMetadataFromJson(json);
}
