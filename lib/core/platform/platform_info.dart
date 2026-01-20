import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Platform information utility for cross-platform support.
///
/// Provides platform detection and UI adaptation helpers.
class PlatformInfo {
  const PlatformInfo._();

  /// Whether the current platform is macOS.
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Whether the current platform is Windows.
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Whether the current platform is Linux.
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Whether the current platform is a desktop platform.
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  /// Whether the current platform is web.
  static bool get isWeb => kIsWeb;

  /// Whether running on Apple platforms (uses Cmd key).
  static bool get isApplePlatform => isMacOS;

  /// The modifier key name for shortcuts (Cmd on macOS, Ctrl elsewhere).
  static String get modifierKeyName => isApplePlatform ? 'Cmd' : 'Ctrl';

  /// The platform name for display purposes.
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// The operating system version string.
  static String get osVersion {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystemVersion;
  }

  /// Default window size for the platform.
  static ({double width, double height}) get defaultWindowSize {
    // macOS typically has larger displays with higher DPI
    if (isMacOS) return (width: 1400.0, height: 900.0);
    // Windows may have smaller default displays
    if (isWindows) return (width: 1280.0, height: 800.0);
    // Linux varies widely, use conservative default
    return (width: 1280.0, height: 800.0);
  }

  /// Minimum window size for the platform.
  static ({double width, double height}) get minimumWindowSize {
    return (width: 960.0, height: 640.0);
  }

  /// Whether to use native file dialogs.
  static bool get useNativeFileDialogs => isDesktop;

  /// The default file extension for project files.
  static const String projectFileExtension = '.forge';

  /// MIME type for project files.
  static const String projectFileMimeType = 'application/x-flutter-forge';

  /// Whether the platform supports drag and drop from Finder/Explorer.
  static bool get supportsDragFromOS => isDesktop;

  /// Whether the platform supports window title updates.
  static bool get supportsWindowTitle => isDesktop;
}

/// Platform-specific UI adjustments.
class PlatformUI {
  const PlatformUI._();

  /// Standard panel padding for the platform.
  static double get panelPadding {
    if (PlatformInfo.isMacOS) return 16.0;
    return 12.0;
  }

  /// Standard item spacing for the platform.
  static double get itemSpacing {
    if (PlatformInfo.isMacOS) return 8.0;
    return 6.0;
  }

  /// Standard border radius for the platform.
  static double get borderRadius {
    if (PlatformInfo.isMacOS) return 8.0;
    if (PlatformInfo.isWindows) return 4.0;
    return 6.0;
  }

  /// Standard icon size for the platform.
  static double get iconSize {
    if (PlatformInfo.isMacOS) return 20.0;
    return 18.0;
  }

  /// Standard font size for labels.
  static double get labelFontSize {
    if (PlatformInfo.isMacOS) return 13.0;
    return 12.0;
  }

  /// Standard font size for body text.
  static double get bodyFontSize {
    if (PlatformInfo.isMacOS) return 14.0;
    return 13.0;
  }

  /// Whether to show window controls in custom title bar.
  static bool get showCustomWindowControls {
    // macOS has native window controls; Windows/Linux need custom
    return PlatformInfo.isWindows || PlatformInfo.isLinux;
  }

  /// The height of the title bar area.
  static double get titleBarHeight {
    if (PlatformInfo.isMacOS) return 28.0;
    if (PlatformInfo.isWindows) return 32.0;
    return 30.0;
  }
}
