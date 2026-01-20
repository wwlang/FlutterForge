import 'package:flutter_forge/services/recent_projects_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Recent Projects (Task 4.5)', () {
    late RecentProjectsService service;
    late InMemoryRecentProjectsStorage storage;

    setUp(() {
      storage = InMemoryRecentProjectsStorage();
      service = RecentProjectsService(storage: storage);
    });

    group('RecentProject Model', () {
      test('creates with required fields', () {
        final project = RecentProject(
          path: '/path/to/project.forge',
          name: 'My Project',
          lastOpened: DateTime(2026, 1, 21),
        );

        expect(project.path, '/path/to/project.forge');
        expect(project.name, 'My Project');
        expect(project.lastOpened.year, 2026);
      });

      test('serializes to JSON', () {
        final project = RecentProject(
          path: '/path/to/project.forge',
          name: 'My Project',
          lastOpened: DateTime(2026, 1, 21),
        );

        final json = project.toJson();
        expect(json['path'], '/path/to/project.forge');
        expect(json['name'], 'My Project');
      });

      test('deserializes from JSON', () {
        final json = {
          'path': '/test/path.forge',
          'name': 'Test',
          'lastOpened': '2026-01-21T10:30:00.000',
        };

        final project = RecentProject.fromJson(json);
        expect(project.path, '/test/path.forge');
        expect(project.name, 'Test');
        expect(project.lastOpened.hour, 10);
      });
    });

    group('Adding Recent Projects', () {
      test('adds project to list', () async {
        await service.addRecentProject(
          path: '/path/to/project.forge',
          name: 'My Project',
        );

        final projects = await service.getRecentProjects();
        expect(projects.length, 1);
        expect(projects.first.name, 'My Project');
      });

      test('most recent appears first', () async {
        await service.addRecentProject(
          path: '/first.forge',
          name: 'First',
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await service.addRecentProject(
          path: '/second.forge',
          name: 'Second',
        );

        final projects = await service.getRecentProjects();
        expect(projects.first.name, 'Second');
      });

      test('reopening moves to top', () async {
        await service.addRecentProject(path: '/first.forge', name: 'First');
        await service.addRecentProject(path: '/second.forge', name: 'Second');
        await service.addRecentProject(path: '/first.forge', name: 'First');

        final projects = await service.getRecentProjects();
        expect(projects.first.name, 'First');
        expect(projects.length, 2); // No duplicates
      });

      test('limits to 10 items', () async {
        for (var i = 0; i < 15; i++) {
          await service.addRecentProject(
            path: '/project$i.forge',
            name: 'Project $i',
          );
        }

        final projects = await service.getRecentProjects();
        expect(projects.length, 10);
      });

      test('oldest removed when limit exceeded', () async {
        for (var i = 0; i < 15; i++) {
          await service.addRecentProject(
            path: '/project$i.forge',
            name: 'Project $i',
          );
          await Future<void>.delayed(const Duration(milliseconds: 5));
        }

        final projects = await service.getRecentProjects();
        // Last added should be first (most recent)
        expect(projects.first.name, 'Project 14');
        // Oldest (0-4) should be removed
        final names = projects.map((p) => p.name).toList();
        expect(names.contains('Project 0'), false);
      });
    });

    group('Removing Recent Projects', () {
      test('removes specific project', () async {
        await service.addRecentProject(path: '/first.forge', name: 'First');
        await service.addRecentProject(path: '/second.forge', name: 'Second');

        await service.removeRecentProject('/first.forge');

        final projects = await service.getRecentProjects();
        expect(projects.length, 1);
        expect(projects.first.name, 'Second');
      });

      test('clears all projects', () async {
        await service.addRecentProject(path: '/first.forge', name: 'First');
        await service.addRecentProject(path: '/second.forge', name: 'Second');

        await service.clearRecentProjects();

        final projects = await service.getRecentProjects();
        expect(projects, isEmpty);
      });
    });

    group('Persistence', () {
      test('persists across service instances', () async {
        await service.addRecentProject(path: '/test.forge', name: 'Test');

        // Create new service with same storage
        final newService = RecentProjectsService(storage: storage);
        final projects = await newService.getRecentProjects();

        expect(projects.length, 1);
        expect(projects.first.name, 'Test');
      });
    });
  });
}
