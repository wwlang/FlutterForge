import 'package:flutter_forge/features/design_system/style_preset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing style presets.
final stylePresetsProvider =
    StateNotifierProvider<StylePresetsNotifier, List<StylePreset>>((ref) {
  return StylePresetsNotifier();
});

/// Notifier for style preset state management.
class StylePresetsNotifier extends StateNotifier<List<StylePreset>> {
  /// Creates a style presets notifier.
  StylePresetsNotifier() : super([]);

  /// Adds a new preset.
  void addPreset(StylePreset preset) {
    state = [...state, preset];
  }

  /// Removes a preset by ID.
  void removePreset(String id) {
    state = state.where((p) => p.id != id).toList();
  }

  /// Updates an existing preset.
  void updatePreset(StylePreset preset) {
    state = [
      for (final p in state)
        if (p.id == preset.id) preset else p,
    ];
  }

  /// Gets a preset by ID.
  StylePreset? getById(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gets all presets in a category.
  List<StylePreset> getByCategory(PresetCategory category) {
    return state.where((p) => p.category == category).toList();
  }

  /// Loads presets from JSON list.
  void loadFromJson(List<dynamic> jsonList) {
    state = jsonList
        .map((json) => StylePreset.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Exports all presets to JSON.
  List<Map<String, dynamic>> toJson() {
    return state.map((p) => p.toJson()).toList();
  }

  /// Loads built-in presets.
  void loadBuiltInPresets() {
    state = [...state, ...getBuiltInPresets()];
  }

  /// Resets to only built-in presets.
  void resetToBuiltIn() {
    state = getBuiltInPresets();
  }
}
