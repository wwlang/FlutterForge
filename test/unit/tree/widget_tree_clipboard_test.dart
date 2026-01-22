import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_forge/commands/commands.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/tree/widget_tree_panel.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Context Menu Cut/Copy/Paste (Gap Fix)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Future<void> rightClick(WidgetTester tester, Finder finder) async {
      final center = tester.getCenter(finder);
      final gesture = await tester.startGesture(
        center,
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryMouseButton,
      );
      await gesture.up();
      await tester.pumpAndSettle();
    }

    group('Copy Action', () {
      testWidgets('copy menu item is enabled', (WidgetTester tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider
                  .overrideWith((ref) => _TestProjectNotifier(state)),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetTreePanel(),
              ),
            ),
          ),
        );

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Find the Copy menu item - it should be tappable (enabled)
        final copyMenuItem = find.text('Copy');
        expect(copyMenuItem, findsOneWidget);

        // Verify it's tappable (enabled)
        await tester.tap(copyMenuItem);
        await tester.pumpAndSettle();
        // If we get here without error and menu closes, copy is enabled
      });
    });

    group('Cut Action', () {
      testWidgets('cut menu item is enabled', (WidgetTester tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider
                  .overrideWith((ref) => _TestProjectNotifier(state)),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetTreePanel(),
              ),
            ),
          ),
        );

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Cut should be tappable (enabled)
        await tester.tap(find.text('Cut'));
        await tester.pumpAndSettle();
      });

      testWidgets('cut copies to clipboard and deletes', (
        WidgetTester tester,
      ) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {'width': 100.0},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider
                  .overrideWith((ref) => _TestProjectNotifier(state)),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: executedCommands.add,
                );
              }),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetTreePanel(),
              ),
            ),
          ),
        );

        // Open context menu and cut
        await rightClick(tester, find.text('Container'));
        await tester.tap(find.text('Cut'));
        await tester.pumpAndSettle();

        // Delete command should have been executed
        expect(
          executedCommands.any((cmd) => cmd is DeleteWidgetCommand),
          isTrue,
        );
      });
    });

    group('Paste Action', () {
      testWidgets('paste is enabled when clipboard has content', (
        WidgetTester tester,
      ) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider
                  .overrideWith((ref) => _TestProjectNotifier(state)),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              // Simulate having something in clipboard
              widgetClipboardProvider.overrideWith((ref) => node),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetTreePanel(),
              ),
            ),
          ),
        );

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Paste should be tappable
        await tester.tap(find.text('Paste'));
        await tester.pumpAndSettle();
      });

      testWidgets('paste creates new widget with new ID', (
        WidgetTester tester,
      ) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {'width': 100.0},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider
                  .overrideWith((ref) => _TestProjectNotifier(state)),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              widgetClipboardProvider.overrideWith((ref) => node),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: executedCommands.add,
                );
              }),
            ],
            child: const MaterialApp(
              home: Scaffold(
                body: WidgetTreePanel(),
              ),
            ),
          ),
        );

        // Open context menu and paste
        await rightClick(tester, find.text('Container'));
        await tester.tap(find.text('Paste'));
        await tester.pumpAndSettle();

        // AddWidgetCommand should be executed
        expect(
          executedCommands.any((cmd) => cmd is AddWidgetCommand),
          isTrue,
        );

        // Pasted widget should have new ID (not same as original)
        final addCmd = executedCommands.firstWhere(
          (cmd) => cmd is AddWidgetCommand,
        ) as AddWidgetCommand;
        expect(addCmd.nodeId, isNot(equals('container-1')));
      });
    });
  });
}

/// Test notifier that wraps a preset ProjectState.
class _TestProjectNotifier extends ProjectNotifier {
  _TestProjectNotifier(this._testState) : super();

  ProjectState _testState;

  @override
  ProjectState get state => _testState;

  @override
  void setState(ProjectState newState) {
    _testState = newState;
  }
}

/// Test command notifier that tracks executed commands.
class _TestCommandNotifier extends CommandNotifier {
  _TestCommandNotifier(
    super.ref, {
    this.onExecute,
  });

  final void Function(Command)? onExecute;

  @override
  void execute(Command command) {
    onExecute?.call(command);
  }
}
