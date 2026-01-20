import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/providers/screens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Multiple Screens (Task 4.7)', () {
    late ProviderContainer container;

    ForgeProject createTestProject({int screenCount = 1}) {
      final screens = List.generate(
        screenCount,
        (i) => ScreenDefinition(
          id: 'screen-$i',
          name: 'Screen ${i + 1}',
          rootNodeId: '',
          nodes: const {},
        ),
      );

      return ForgeProject(
        id: 'test-id',
        name: 'Test Project',
        screens: screens,
        metadata: ProjectMetadata(
          createdAt: DateTime(2026, 1, 21),
          modifiedAt: DateTime(2026, 1, 21),
          forgeVersion: '1.0.0',
        ),
      );
    }

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Screen Provider', () {
      test('initializes with project screens', () {
        final project = createTestProject(screenCount: 2);
        container.read(screensProvider.notifier).setProject(project);

        final state = container.read(screensProvider);
        expect(state.screens.length, 2);
        expect(state.screens[0].name, 'Screen 1');
      });

      test('tracks current screen selection', () {
        final project = createTestProject(screenCount: 3);
        container.read(screensProvider.notifier).setProject(project);

        expect(container.read(screensProvider).currentScreenId, 'screen-0');

        container.read(screensProvider.notifier).selectScreen('screen-1');

        expect(container.read(screensProvider).currentScreenId, 'screen-1');
      });
    });

    group('Add Screen', () {
      test('adds new screen to project', () {
        final project = createTestProject(screenCount: 1);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).addScreen();

        final state = container.read(screensProvider);
        expect(state.screens.length, 2);
      });

      test('new screen has default name', () {
        final project = createTestProject(screenCount: 1);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).addScreen();

        final state = container.read(screensProvider);
        expect(state.screens.last.name, 'Screen 2');
      });

      test('new screen is empty', () {
        final project = createTestProject(screenCount: 1);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).addScreen();

        final state = container.read(screensProvider);
        expect(state.screens.last.nodes, isEmpty);
      });
    });

    group('Rename Screen', () {
      test('renames specific screen', () {
        final project = createTestProject(screenCount: 2);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).renameScreen(
              'screen-0',
              'HomeScreen',
            );

        final state = container.read(screensProvider);
        expect(state.screens.first.name, 'HomeScreen');
      });

      test('does not rename non-existent screen', () {
        final project = createTestProject(screenCount: 1);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).renameScreen(
              'non-existent',
              'New Name',
            );

        final state = container.read(screensProvider);
        expect(state.screens.first.name, 'Screen 1');
      });
    });

    group('Delete Screen', () {
      test('deletes specific screen', () {
        final project = createTestProject(screenCount: 3);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).deleteScreen('screen-1');

        final state = container.read(screensProvider);
        expect(state.screens.length, 2);
        expect(state.screens.any((s) => s.id == 'screen-1'), false);
      });

      test('cannot delete last screen', () {
        final project = createTestProject(screenCount: 1);
        container.read(screensProvider.notifier).setProject(project);

        container.read(screensProvider.notifier).deleteScreen('screen-0');

        final state = container.read(screensProvider);
        expect(state.screens.length, 1);
      });

      test('selects next screen when current deleted', () {
        final project = createTestProject(screenCount: 3);
        container.read(screensProvider.notifier).setProject(project);
        container.read(screensProvider.notifier).selectScreen('screen-1');

        container.read(screensProvider.notifier).deleteScreen('screen-1');

        final state = container.read(screensProvider);
        expect(state.currentScreenId, isNot('screen-1'));
      });
    });

    group('Screen Helpers', () {
      test('gets current screen', () {
        final project = createTestProject(screenCount: 2);
        container.read(screensProvider.notifier).setProject(project);
        container.read(screensProvider.notifier).selectScreen('screen-1');

        final currentScreen = container.read(currentScreenProvider);
        expect(currentScreen?.id, 'screen-1');
      });

      test('current screen is null when no project', () {
        final currentScreen = container.read(currentScreenProvider);
        expect(currentScreen, isNull);
      });
    });
  });
}
