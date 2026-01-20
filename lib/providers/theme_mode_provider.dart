import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for theme settings including mode and high contrast.
class ThemeSettings {
  const ThemeSettings({
    this.themeMode = ThemeMode.light,
    this.isHighContrast = false,
  });

  final ThemeMode themeMode;
  final bool isHighContrast;

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    bool? isHighContrast,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      isHighContrast: isHighContrast ?? this.isHighContrast,
    );
  }
}

/// Provides the current theme settings (mode and high contrast).
final themeSettingsProvider =
    StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>((ref) {
  return ThemeSettingsNotifier();
});

/// Provides the current theme mode (light, dark, system).
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeSettingsProvider).themeMode;
});

/// Provides whether high contrast mode is enabled.
final isHighContrastProvider = Provider<bool>((ref) {
  return ref.watch(themeSettingsProvider).isHighContrast;
});

/// Notifier for managing theme settings state.
class ThemeSettingsNotifier extends StateNotifier<ThemeSettings> {
  ThemeSettingsNotifier() : super(const ThemeSettings());

  /// Sets the theme mode directly.
  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// Cycles through theme modes: Light -> Dark -> System -> Light.
  void cycle() {
    state = state.copyWith(
      themeMode: switch (state.themeMode) {
        ThemeMode.light => ThemeMode.dark,
        ThemeMode.dark => ThemeMode.system,
        ThemeMode.system => ThemeMode.light,
      },
    );
  }

  /// Sets high contrast mode.
  void setHighContrast(bool enabled) {
    state = state.copyWith(isHighContrast: enabled);
  }
}

/// Notifier wrapper for convenience that delegates to ThemeSettingsNotifier.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._settingsNotifier) : super(ThemeMode.light);

  final ThemeSettingsNotifier _settingsNotifier;

  void setThemeMode(ThemeMode mode) {
    _settingsNotifier.setThemeMode(mode);
    state = mode;
  }

  void cycle() {
    _settingsNotifier.cycle();
    state = _settingsNotifier.state.themeMode;
  }

  void setHighContrast(bool enabled) {
    _settingsNotifier.setHighContrast(enabled);
  }
}

/// Extension to get the effective brightness based on theme mode and platform.
extension ThemeModeExtension on ThemeMode {
  /// Returns the effective brightness for this theme mode.
  ///
  /// [platformBrightness] is only used when mode is [ThemeMode.system].
  Brightness effectiveBrightness(Brightness platformBrightness) {
    return switch (this) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };
  }
}

/// Returns the appropriate color value from a token based on current settings.
int getTokenColorValue({
  required int lightValue,
  required int darkValue,
  required ThemeMode themeMode,
  required Brightness platformBrightness,
  required bool isHighContrast,
  int? highContrastLightValue,
  int? highContrastDarkValue,
}) {
  final isDark =
      themeMode.effectiveBrightness(platformBrightness) == Brightness.dark;

  if (isHighContrast) {
    if (isDark) {
      return highContrastDarkValue ?? darkValue;
    } else {
      return highContrastLightValue ?? lightValue;
    }
  }

  return isDark ? darkValue : lightValue;
}
