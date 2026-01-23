import 'package:flutter_forge/features/code_preview/code_preview_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for code generation settings (J19 S3).
///
/// Manages Dart version targeting and shorthand preferences.
final codeSettingsProvider =
    NotifierProvider<CodeSettingsNotifier, CodeSettings>(
  CodeSettingsNotifier.new,
);

/// Notifier for code generation settings.
class CodeSettingsNotifier extends Notifier<CodeSettings> {
  @override
  CodeSettings build() => const CodeSettings();

  /// Sets the target Dart version.
  ///
  /// Automatically adjusts shorthand setting based on version support.
  void setDartVersion(DartVersion version) {
    state = state.copyWith(
      dartVersion: version,
      useDotShorthand: version.supportsShorthand && state.useDotShorthand,
    );
  }

  /// Sets the dot shorthand preference.
  ///
  /// Only effective for Dart 3.10+. Setting to true for Dart 3.9
  /// will be ignored.
  void setDotShorthand({required bool enabled}) {
    // Only allow enabling shorthand if version supports it
    final effectiveEnabled = enabled && state.dartVersion.supportsShorthand;
    state = state.copyWith(useDotShorthand: effectiveEnabled);
  }

  /// Resets to default settings.
  void reset() {
    state = const CodeSettings();
  }

  /// Loads settings from project metadata.
  void loadFromMetadata(String? targetDartVersion) {
    if (targetDartVersion == null) {
      state = const CodeSettings();
      return;
    }

    final dartVersion = targetDartVersion == 'dart39'
        ? DartVersion.dart39
        : DartVersion.dart310;

    state = CodeSettings(
      dartVersion: dartVersion,
      useDotShorthand: dartVersion.supportsShorthand,
    );
  }
}
