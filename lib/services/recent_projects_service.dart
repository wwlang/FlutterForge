import 'dart:convert';

/// A recently opened project entry.
class RecentProject {
  const RecentProject({
    required this.path,
    required this.name,
    required this.lastOpened,
  });

  /// Creates a recent project from JSON.
  factory RecentProject.fromJson(Map<String, dynamic> json) => RecentProject(
        path: json['path'] as String,
        name: json['name'] as String,
        lastOpened: DateTime.parse(json['lastOpened'] as String),
      );

  /// Path to the .forge file.
  final String path;

  /// Project name (for display when file might not exist).
  final String name;

  /// When the project was last opened.
  final DateTime lastOpened;

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        'lastOpened': lastOpened.toIso8601String(),
      };

  RecentProject copyWith({
    String? path,
    String? name,
    DateTime? lastOpened,
  }) {
    return RecentProject(
      path: path ?? this.path,
      name: name ?? this.name,
      lastOpened: lastOpened ?? this.lastOpened,
    );
  }
}

/// Abstract storage interface for recent projects.
abstract class RecentProjectsStorage {
  Future<List<RecentProject>> load();
  Future<void> save(List<RecentProject> projects);
}

/// In-memory storage for testing.
class InMemoryRecentProjectsStorage implements RecentProjectsStorage {
  List<RecentProject> _projects = [];

  @override
  Future<List<RecentProject>> load() async => List.from(_projects);

  @override
  Future<void> save(List<RecentProject> projects) async {
    _projects = List.from(projects);
  }
}

/// Service for managing recently opened projects.
class RecentProjectsService {
  RecentProjectsService({required this.storage});

  /// Maximum number of recent projects to keep.
  static const maxRecentProjects = 10;

  final RecentProjectsStorage storage;

  /// Gets the list of recent projects, most recent first.
  Future<List<RecentProject>> getRecentProjects() async {
    final projects = await storage.load();
    // Sort by lastOpened descending (most recent first)
    projects.sort((a, b) => b.lastOpened.compareTo(a.lastOpened));
    return projects;
  }

  /// Adds or updates a project in the recent list.
  Future<void> addRecentProject({
    required String path,
    required String name,
  }) async {
    final projects = await storage.load()
      // Remove existing entry for same path
      ..removeWhere((p) => p.path == path)
      // Add new entry
      ..add(
        RecentProject(
          path: path,
          name: name,
          lastOpened: DateTime.now(),
        ),
      )
      // Sort by lastOpened descending
      ..sort((a, b) => b.lastOpened.compareTo(a.lastOpened));

    // Trim to max size
    final trimmed = projects.take(maxRecentProjects).toList();

    await storage.save(trimmed);
  }

  /// Removes a project from the recent list.
  Future<void> removeRecentProject(String path) async {
    final projects = await storage.load();
    projects.removeWhere((p) => p.path == path);
    await storage.save(projects);
  }

  /// Clears all recent projects.
  Future<void> clearRecentProjects() async {
    await storage.save([]);
  }
}

/// Shared preferences storage for recent projects.
class SharedPreferencesRecentProjectsStorage implements RecentProjectsStorage {
  SharedPreferencesRecentProjectsStorage();

  static const _key = 'recent_projects';

  // This would use SharedPreferences in production
  // For now, just a placeholder that uses an in-memory map
  final Map<String, String> _prefs = {};

  @override
  Future<List<RecentProject>> load() async {
    final json = _prefs[_key];
    if (json == null || json.isEmpty) return [];

    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => RecentProject.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> save(List<RecentProject> projects) async {
    final json = jsonEncode(projects.map((p) => p.toJson()).toList());
    _prefs[_key] = json;
  }
}
