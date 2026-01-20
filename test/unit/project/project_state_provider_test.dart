import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/providers/project_state_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Project State Provider (Tasks 4.2-4.4)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('New Project Flow (Task 4.2)', () {
      test('creates new project with name', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'My Project');

        final state = container.read(currentProjectProvider);
        expect(state.project?.name, 'My Project');
        expect(state.isDirty, false);
      });

      test('new project clears file path', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'Test');

        final state = container.read(currentProjectProvider);
        expect(state.filePath, isNull);
      });

      test('new project has default name if not specified', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject();

        final state = container.read(currentProjectProvider);
        expect(state.project?.name, 'Untitled Project');
      });
    });

    group('Dirty State Tracking', () {
      test('marks project as dirty when modified', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'Test');

        expect(container.read(currentProjectProvider).isDirty, false);

        notifier.markDirty();

        expect(container.read(currentProjectProvider).isDirty, true);
      });

      test('marks project as clean after save', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'Test');
        notifier.markDirty();

        expect(container.read(currentProjectProvider).isDirty, true);

        notifier.markClean('/path/to/file.forge');

        final state = container.read(currentProjectProvider);
        expect(state.isDirty, false);
        expect(state.filePath, '/path/to/file.forge');
      });
    });

    group('Project Loading (Task 4.4)', () {
      test('loads project from ForgeProject', () {
        final project = ForgeProject(
          id: 'test-id',
          name: 'Loaded Project',
          screens: const [],
          metadata: ProjectMetadata(
            createdAt: DateTime(2026, 1, 21),
            modifiedAt: DateTime(2026, 1, 21),
            forgeVersion: '1.0.0',
          ),
        );

        final notifier = container.read(currentProjectProvider.notifier);
        notifier.loadProject(project, '/path/to/project.forge');

        final state = container.read(currentProjectProvider);
        expect(state.project?.name, 'Loaded Project');
        expect(state.filePath, '/path/to/project.forge');
        expect(state.isDirty, false);
      });
    });

    group('Title Display', () {
      test('title shows project name', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'My App');

        final title = container.read(windowTitleProvider);
        expect(title, contains('My App'));
      });

      test('title shows dirty indicator when modified', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'My App');
        notifier.markDirty();

        final title = container.read(windowTitleProvider);
        expect(title, contains('*'));
      });

      test('title includes file path when saved', () {
        final notifier = container.read(currentProjectProvider.notifier);
        notifier.createNewProject(name: 'My App');
        notifier.markClean('/Users/test/My App.forge');

        final title = container.read(windowTitleProvider);
        expect(title, contains('My App.forge'));
      });
    });
  });
}
