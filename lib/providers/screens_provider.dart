import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// State for managing multiple screens within a project.
class ScreensState {
  const ScreensState({
    this.screens = const [],
    this.currentScreenId,
  });

  /// List of screens in the project.
  final List<ScreenDefinition> screens;

  /// Currently selected screen ID.
  final String? currentScreenId;

  /// Gets the current screen definition.
  ScreenDefinition? get currentScreen {
    if (currentScreenId == null) return null;
    try {
      return screens.firstWhere((s) => s.id == currentScreenId);
    } catch (_) {
      return screens.isNotEmpty ? screens.first : null;
    }
  }

  ScreensState copyWith({
    List<ScreenDefinition>? screens,
    String? currentScreenId,
  }) {
    return ScreensState(
      screens: screens ?? this.screens,
      currentScreenId: currentScreenId ?? this.currentScreenId,
    );
  }
}

/// Provider for managing screens within a project.
final screensProvider = StateNotifierProvider<ScreensNotifier, ScreensState>(
  (ref) => ScreensNotifier(),
);

/// Notifier for screens state.
class ScreensNotifier extends StateNotifier<ScreensState> {
  ScreensNotifier() : super(const ScreensState());

  static const _uuid = Uuid();

  /// Sets the project and its screens.
  void setProject(ForgeProject project) {
    state = ScreensState(
      screens: project.screens,
      currentScreenId:
          project.screens.isNotEmpty ? project.screens.first.id : null,
    );
  }

  /// Selects a screen by ID.
  void selectScreen(String screenId) {
    if (state.screens.any((s) => s.id == screenId)) {
      state = state.copyWith(currentScreenId: screenId);
    }
  }

  /// Adds a new empty screen.
  void addScreen({String? name}) {
    final screenNumber = state.screens.length + 1;
    final newScreen = ScreenDefinition(
      id: _uuid.v4(),
      name: name ?? 'Screen $screenNumber',
      rootNodeId: '',
      nodes: const {},
    );

    state = state.copyWith(
      screens: [...state.screens, newScreen],
    );
  }

  /// Renames a screen.
  void renameScreen(String screenId, String newName) {
    final index = state.screens.indexWhere((s) => s.id == screenId);
    if (index < 0) return;

    final screens = List<ScreenDefinition>.from(state.screens);
    screens[index] = screens[index].copyWith(name: newName);
    state = state.copyWith(screens: screens);
  }

  /// Deletes a screen.
  void deleteScreen(String screenId) {
    // Cannot delete last screen
    if (state.screens.length <= 1) return;

    final screens = state.screens.where((s) => s.id != screenId).toList();

    // Select a different screen if current was deleted
    var newCurrentId = state.currentScreenId;
    if (state.currentScreenId == screenId) {
      newCurrentId = screens.isNotEmpty ? screens.first.id : null;
    }

    state = ScreensState(
      screens: screens,
      currentScreenId: newCurrentId,
    );
  }

  /// Updates a screen's nodes.
  void updateScreenNodes(
    String screenId,
    Map<String, dynamic> nodes,
    String? rootNodeId,
  ) {
    final index = state.screens.indexWhere((s) => s.id == screenId);
    if (index < 0) return;

    final screens = List<ScreenDefinition>.from(state.screens);
    screens[index] = screens[index].copyWith(
      nodes: nodes,
      rootNodeId: rootNodeId ?? screens[index].rootNodeId,
    );
    state = state.copyWith(screens: screens);
  }

  /// Clears all screens.
  void clear() {
    state = const ScreensState();
  }

  /// Gets the updated project with current screens.
  ForgeProject? applyToProject(ForgeProject? project) {
    if (project == null) return null;
    return project.copyWith(screens: state.screens);
  }
}

/// Provider for getting the current screen.
final currentScreenProvider = Provider<ScreenDefinition?>((ref) {
  return ref.watch(screensProvider).currentScreen;
});
