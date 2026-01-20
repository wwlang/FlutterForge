import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/commands/commands.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/tree/widget_tree_panel.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tree Context Menu (Task 2.6)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget buildTestWidget({
      required ProjectState projectState,
      String? selectedId,
      List<Override>? additionalOverrides,
    }) {
      return ProviderScope(
        overrides: [
          projectProvider.overrideWith(
            (ref) => _TestProjectNotifier(projectState),
          ),
          selectionProvider.overrideWith((ref) => selectedId),
          widgetRegistryProvider.overrideWith((ref) => registry),
          ...?additionalOverrides,
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: WidgetTreePanel(),
          ),
        ),
      );
    }

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

    group('Context Menu Display', () {
      testWidgets('right-click on tree node shows context menu',
          (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Right-click on the container
        await rightClick(tester, find.text('Container'));

        // Context menu should appear with Delete option
        expect(find.text('Delete'), findsOneWidget);
      });

      testWidgets('context menu shows all expected items', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Right-click to open menu
        await rightClick(tester, find.text('Container'));

        // Verify menu items
        expect(find.text('Cut'), findsOneWidget);
        expect(find.text('Copy'), findsOneWidget);
        expect(find.text('Paste'), findsOneWidget);
        expect(find.text('Duplicate'), findsOneWidget);
        expect(find.text('Delete'), findsOneWidget);
        expect(find.text('Wrap in...'), findsOneWidget);
      });

      testWidgets('menu items show keyboard shortcuts', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Check for keyboard shortcut indicators (symbols like Cmd/Ctrl)
        // The shortcut text contains the key letter
        expect(find.textContaining('X'), findsWidgets); // Cut shortcut
        expect(find.textContaining('C'), findsWidgets); // Copy shortcut
        expect(find.textContaining('V'), findsWidgets); // Paste shortcut
        expect(find.textContaining('D'), findsWidgets); // Duplicate shortcut
      });
    });

    group('Delete Operations', () {
      testWidgets('delete leaf widget removes it via command', (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
          childrenIds: ['text-1'],
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
          parentId: 'container-1',
        );
        var state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith((ref) {
                return _TestProjectNotifier(state);
              }),
              selectionProvider.overrideWith((ref) => 'text-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Right-click on text (leaf node)
        await rightClick(tester, find.text('Text'));

        // Click delete
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // DeleteWidgetCommand should be executed (leaf nodes delete immediately)
        expect(
          executedCommands.any((cmd) => cmd is DeleteWidgetCommand),
          isTrue,
        );
      });

      testWidgets('delete widget with children shows confirmation dialog',
          (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
          childrenIds: ['text-1'],
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
          parentId: 'container-1',
        );
        const state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Right-click on container (has children)
        await rightClick(tester, find.text('Container'));

        // Click delete
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Confirmation dialog should appear
        expect(find.text('Delete Widget?'), findsOneWidget);
        expect(find.textContaining('1 child'), findsOneWidget);
      });

      testWidgets('cancel delete keeps widget', (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
          childrenIds: ['text-1'],
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
          parentId: 'container-1',
        );
        const state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith(
                (ref) => _TestProjectNotifier(state),
              ),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Right-click and delete
        await rightClick(tester, find.text('Container'));
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Cancel the deletion
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // No command should have been executed
        expect(executedCommands, isEmpty);
      });

      testWidgets('confirm delete executes command', (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
          childrenIds: ['text-1'],
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
          parentId: 'container-1',
        );
        const state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith(
                (ref) => _TestProjectNotifier(state),
              ),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Right-click and delete
        await rightClick(tester, find.text('Container'));
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Confirm the deletion
        await tester.tap(find.text('Delete').last);
        await tester.pumpAndSettle();

        // DeleteWidgetCommand should have been executed
        expect(executedCommands.length, equals(1));
        expect(executedCommands.first, isA<DeleteWidgetCommand>());
      });

      testWidgets('Delete key triggers delete on selected widget',
          (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        var state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith((ref) {
                return _TestProjectNotifier(state);
              }),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Focus the tree panel by tapping
        await tester.tap(find.text('Container'));
        await tester.pumpAndSettle();

        // Press Delete key
        await tester.sendKeyEvent(LogicalKeyboardKey.delete);
        await tester.pumpAndSettle();

        // DeleteWidgetCommand should be executed
        expect(
          executedCommands.any((cmd) => cmd is DeleteWidgetCommand),
          isTrue,
        );
      });

      testWidgets('Backspace key triggers delete', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        var state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith((ref) {
                return _TestProjectNotifier(state);
              }),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Focus and press Backspace key
        await tester.tap(find.text('Container'));
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
        await tester.pumpAndSettle();

        // DeleteWidgetCommand should be executed
        expect(
          executedCommands.any((cmd) => cmd is DeleteWidgetCommand),
          isTrue,
        );
      });

      testWidgets('delete uses DeleteWidgetCommand for undo support',
          (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        var state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith((ref) {
                return _TestProjectNotifier(state);
              }),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Right-click and delete
        await rightClick(tester, find.text('Container'));
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Verify DeleteWidgetCommand was used
        expect(executedCommands.length, equals(1));
        expect(executedCommands.first, isA<DeleteWidgetCommand>());
        expect(
          (executedCommands.first as DeleteWidgetCommand).nodeId,
          equals('container-1'),
        );
      });
    });

    group('Cut/Copy/Paste Operations', () {
      testWidgets('cut is visible (placeholder for Phase 4)', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Cut should be visible
        expect(find.text('Cut'), findsOneWidget);
      });

      testWidgets('copy is visible (placeholder for Phase 4)', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Copy should be visible
        expect(find.text('Copy'), findsOneWidget);
      });

      testWidgets('paste is visible (placeholder for Phase 4)', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'container-1',
        ));

        // Open context menu
        await rightClick(tester, find.text('Container'));

        // Paste should be visible
        expect(find.text('Paste'), findsOneWidget);
      });
    });

    group('Duplicate Operation', () {
      testWidgets('duplicate creates a copy of the widget', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {'padding': 16.0},
        );
        var state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith((ref) {
                return _TestProjectNotifier(state);
              }),
              selectionProvider.overrideWith((ref) => 'container-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Right-click and duplicate
        await rightClick(tester, find.text('Container'));
        await tester.tap(find.text('Duplicate'));
        await tester.pumpAndSettle();

        // AddWidgetCommand should be executed for duplication
        expect(
          executedCommands.any((cmd) => cmd is AddWidgetCommand),
          isTrue,
        );
      });
    });

    group('Wrap In Submenu', () {
      testWidgets('wrap in submenu shows wrapper options', (tester) async {
        const node = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'text-1': node},
          rootIds: ['text-1'],
        );

        await tester.pumpWidget(buildTestWidget(
          projectState: state,
          selectedId: 'text-1',
        ));

        // Open context menu
        await rightClick(tester, find.text('Text'));

        // Click on "Wrap in..."
        await tester.tap(find.text('Wrap in...'));
        await tester.pumpAndSettle();

        // Submenu should show wrapper options
        expect(find.text('Container'), findsWidgets);
        expect(find.text('Padding'), findsOneWidget);
        expect(find.text('Center'), findsOneWidget);
      });

      testWidgets('wrap in Container wraps the widget', (tester) async {
        const node = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        var state = ProjectState(
          nodes: {'text-1': node},
          rootIds: ['text-1'],
        );

        final executedCommands = <Command>[];

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith((ref) {
                return _TestProjectNotifier(state);
              }),
              selectionProvider.overrideWith((ref) => 'text-1'),
              widgetRegistryProvider.overrideWith((ref) => registry),
              commandProvider.overrideWith((ref) {
                return _TestCommandNotifier(
                  ref,
                  onExecute: (cmd) => executedCommands.add(cmd),
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

        // Open context menu and wrap in Container
        await rightClick(tester, find.text('Text'));
        await tester.tap(find.text('Wrap in...'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Container').last);
        await tester.pumpAndSettle();

        // Commands should be executed for wrapping
        expect(executedCommands.isNotEmpty, isTrue);
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
