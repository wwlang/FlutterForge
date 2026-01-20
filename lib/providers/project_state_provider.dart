import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/services/project_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

/// State representing the current project and its save status.
class CurrentProjectState {
  const CurrentProjectState({
    this.project,
    this.filePath,
    this.isDirty = false,
  });

  /// The currently open project, or null if no project is open.
  final ForgeProject? project;

  /// Path to the file if saved, or null for new unsaved project.
  final String? filePath;

  /// Whether the project has unsaved changes.
  final bool isDirty;

  CurrentProjectState copyWith({
    ForgeProject? project,
    String? filePath,
    bool? isDirty,
    bool clearFilePath = false,
  }) {
    return CurrentProjectState(
      project: project ?? this.project,
      filePath: clearFilePath ? null : (filePath ?? this.filePath),
      isDirty: isDirty ?? this.isDirty,
    );
  }
}

/// Provider for managing current project state.
final currentProjectProvider =
    StateNotifierProvider<CurrentProjectNotifier, CurrentProjectState>(
  (ref) => CurrentProjectNotifier(ProjectService()),
);

/// Notifier for current project state.
class CurrentProjectNotifier extends StateNotifier<CurrentProjectState> {
  CurrentProjectNotifier(this._projectService)
      : super(const CurrentProjectState());

  final ProjectService _projectService;

  /// Creates a new project.
  void createNewProject({String? name}) {
    final project = _projectService.createNewProject(
      name: name ?? 'Untitled Project',
    );
    state = CurrentProjectState(project: project);
  }

  /// Loads an existing project.
  void loadProject(ForgeProject project, String filePath) {
    state = CurrentProjectState(
      project: project,
      filePath: filePath,
    );
  }

  /// Marks the project as having unsaved changes.
  void markDirty() {
    if (state.project != null) {
      state = state.copyWith(isDirty: true);
    }
  }

  /// Marks the project as saved with the given file path.
  void markClean(String filePath) {
    if (state.project != null) {
      state = state.copyWith(
        isDirty: false,
        filePath: filePath,
      );
    }
  }

  /// Updates the project.
  void updateProject(ForgeProject project) {
    state = state.copyWith(project: project, isDirty: true);
  }

  /// Clears the current project.
  void closeProject() {
    state = const CurrentProjectState();
  }
}

/// Provider for the window title based on project state.
final windowTitleProvider = Provider<String>((ref) {
  final projectState = ref.watch(currentProjectProvider);

  if (projectState.project == null) {
    return 'FlutterForge';
  }

  final name = projectState.project!.name;
  final dirty = projectState.isDirty ? '*' : '';
  final filePath = projectState.filePath;

  if (filePath != null) {
    final fileName = p.basename(filePath);
    return '$dirty$fileName - FlutterForge';
  }

  return '$dirty$name - FlutterForge';
});
