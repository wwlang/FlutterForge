import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_preview_settings.freezed.dart';
part 'code_preview_settings.g.dart';

/// Dart version targeting for code generation (J19 S3).
///
/// Controls whether generated code uses Dart 3.10+ features like
/// dot shorthand syntax.
enum DartVersion {
  /// Dart 3.9 compatibility mode - no shorthand syntax.
  dart39,

  /// Dart 3.10+ with dot shorthand syntax support.
  dart310;

  /// Human-readable display name for UI.
  String get displayName => switch (this) {
        DartVersion.dart39 => 'Dart 3.9 (Legacy)',
        DartVersion.dart310 => 'Dart 3.10+ (Shorthand)',
      };

  /// Short display name for compact UI.
  String get shortName => switch (this) {
        DartVersion.dart39 => 'Dart 3.9',
        DartVersion.dart310 => 'Dart 3.10+',
      };

  /// Minimum SDK constraint for pubspec.yaml.
  String get minSdkConstraint => switch (this) {
        DartVersion.dart39 => '^3.9.0',
        DartVersion.dart310 => '^3.10.0',
      };

  /// Whether this version supports dot shorthand syntax.
  bool get supportsShorthand => this == DartVersion.dart310;
}

/// Code generation settings for export.
///
/// Controls Dart version targeting and code style options.
@freezed
class CodeSettings with _$CodeSettings {
  /// Creates code generation settings.
  ///
  /// [dartVersion] defaults to Dart 3.10+ for modern code.
  /// [useDotShorthand] defaults to true for Dart 3.10+.
  const factory CodeSettings({
    /// Target Dart version for generated code.
    @Default(DartVersion.dart310) DartVersion dartVersion,

    /// Whether to use dot shorthand syntax (Dart 3.10+).
    ///
    /// Automatically false for Dart 3.9, but can be manually
    /// disabled for Dart 3.10+ if desired.
    @Default(true) bool useDotShorthand,
  }) = _CodeSettings;

  const CodeSettings._();

  /// Creates settings from JSON.
  factory CodeSettings.fromJson(Map<String, dynamic> json) =>
      _$CodeSettingsFromJson(json);

  /// Creates settings from project metadata.
  factory CodeSettings.fromProjectMetadata(ProjectMetadata metadata) {
    final versionString = metadata.targetDartVersion;
    final dartVersion =
        versionString == 'dart39' ? DartVersion.dart39 : DartVersion.dart310;

    return CodeSettings(
      dartVersion: dartVersion,
      useDotShorthand: dartVersion.supportsShorthand,
    );
  }

  /// Effective shorthand setting (respects Dart version).
  ///
  /// Returns false if Dart version doesn't support shorthand,
  /// even if [useDotShorthand] is true.
  bool get effectiveShorthand =>
      dartVersion.supportsShorthand && useDotShorthand;
}
