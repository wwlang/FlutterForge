import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/tree/widget_tree_item.dart';
import 'package:flutter_forge/features/tree/widget_tree_panel.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tree Selection Sync (Task 2.4)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget buildTestWidget({
      required ProjectState projectState,
      String? selectedId,
    }) {
      return ProviderScope(
        overrides: [
          projectProvider.overrideWith(
            (ref) => _TestProjectNotifier(projectState),
          ),
          selectionProvider.overrideWith((ref) => selectedId),
          widgetRegistryProvider.overrideWith((ref) => registry),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: WidgetTreePanel(),
          ),
        ),
      );
    }

    group('Tree Node Click Selection', () {
      testWidgets('clicking tree node updates selection', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        String? selectedId;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith(
                (ref) => _TestProjectNotifier(state),
              ),
              widgetRegistryProvider.overrideWith((ref) => registry),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, child) {
                    selectedId = ref.watch(selectionProvider);
                    return const WidgetTreePanel();
                  },
                ),
              ),
            ),
          ),
        );

        // Initially no selection
        expect(selectedId, isNull);

        // Tap on the tree item
        await tester.tap(find.text('Container'));
        await tester.pumpAndSettle();

        // Should now be selected
        expect(selectedId, equals('container-1'));
      });

      testWidgets('clicking different node changes selection', (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1', 'text-1'],
        );

        String? selectedId;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith(
                (ref) => _TestProjectNotifier(state),
              ),
              widgetRegistryProvider.overrideWith((ref) => registry),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, child) {
                    selectedId = ref.watch(selectionProvider);
                    return const WidgetTreePanel();
                  },
                ),
              ),
            ),
          ),
        );

        // Select Container
        await tester.tap(find.text('Container'));
        await tester.pumpAndSettle();
        expect(selectedId, equals('container-1'));

        // Select Text
        await tester.tap(find.text('Text'));
        await tester.pumpAndSettle();
        expect(selectedId, equals('text-1'));
      });

      testWidgets('clicking nested node selects it', (tester) async {
        const parent = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
          childrenIds: ['text-1'],
        );
        const child = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
          parentId: 'container-1',
        );
        const state = ProjectState(
          nodes: {'container-1': parent, 'text-1': child},
          rootIds: ['container-1'],
        );

        String? selectedId;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith(
                (ref) => _TestProjectNotifier(state),
              ),
              widgetRegistryProvider.overrideWith((ref) => registry),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, child) {
                    selectedId = ref.watch(selectionProvider);
                    return const WidgetTreePanel();
                  },
                ),
              ),
            ),
          ),
        );

        // Select nested Text widget
        await tester.tap(find.text('Text'));
        await tester.pumpAndSettle();
        expect(selectedId, equals('text-1'));
      });
    });

    group('Selection Visual Feedback', () {
      testWidgets('selected node shows highlight', (tester) async {
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
          buildTestWidget(
            projectState: state,
            selectedId: 'container-1',
          ),
        );

        final item = tester.widget<WidgetTreeItem>(
          find.byType(WidgetTreeItem),
        );
        expect(item.isSelected, isTrue);
      });

      testWidgets('unselected node shows no highlight', (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1', 'text-1'],
        );

        await tester.pumpWidget(
          buildTestWidget(
            projectState: state,
            selectedId: 'container-1',
          ),
        );

        final textItem = tester.widget<WidgetTreeItem>(
          find.byWidgetPredicate(
            (widget) => widget is WidgetTreeItem && widget.nodeId == 'text-1',
          ),
        );
        expect(textItem.isSelected, isFalse);
      });
    });

    group('Auto-Expand on Selection', () {
      testWidgets(
        'collapsed parent auto-expands when child selected via tap',
        (tester) async {
          const parent = WidgetNode(
            id: 'container-1',
            type: 'Container',
            properties: {},
            childrenIds: ['text-1'],
          );
          const child = WidgetNode(
            id: 'text-1',
            type: 'Text',
            properties: {},
            parentId: 'container-1',
          );
          const state = ProjectState(
            nodes: {'container-1': parent, 'text-1': child},
            rootIds: ['container-1'],
          );

          String? selectedId;
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                projectProvider.overrideWith(
                  (ref) => _TestProjectNotifier(state),
                ),
                widgetRegistryProvider.overrideWith((ref) => registry),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: Consumer(
                    builder: (context, ref, child) {
                      selectedId = ref.watch(selectionProvider);
                      return const WidgetTreePanel();
                    },
                  ),
                ),
              ),
            ),
          );

          // Child should be visible initially
          expect(find.text('Text'), findsOneWidget);

          // Collapse the parent
          await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
          await tester.pumpAndSettle();

          // Child should be hidden
          expect(find.text('Text'), findsNothing);

          // Tap parent to expand
          await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
          await tester.pumpAndSettle();

          // Child should be visible and we can tap it
          expect(find.text('Text'), findsOneWidget);
          await tester.tap(find.text('Text'));
          await tester.pumpAndSettle();

          // Should be selected
          expect(selectedId, equals('text-1'));
        },
      );

      testWidgets(
        'selecting child while parent expanded shows selection',
        (tester) async {
          const root = WidgetNode(
            id: 'column-1',
            type: 'Column',
            properties: {},
            childrenIds: ['container-1'],
          );
          const container = WidgetNode(
            id: 'container-1',
            type: 'Container',
            properties: {},
            parentId: 'column-1',
            childrenIds: ['text-1'],
          );
          const text = WidgetNode(
            id: 'text-1',
            type: 'Text',
            properties: {},
            parentId: 'container-1',
          );
          const state = ProjectState(
            nodes: {
              'column-1': root,
              'container-1': container,
              'text-1': text,
            },
            rootIds: ['column-1'],
          );

          String? selectedId;
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                projectProvider.overrideWith(
                  (ref) => _TestProjectNotifier(state),
                ),
                widgetRegistryProvider.overrideWith((ref) => registry),
              ],
              child: MaterialApp(
                home: Scaffold(
                  body: Consumer(
                    builder: (context, ref, child) {
                      selectedId = ref.watch(selectionProvider);
                      return const WidgetTreePanel();
                    },
                  ),
                ),
              ),
            ),
          );

          // All visible initially
          expect(find.text('Column'), findsOneWidget);
          expect(find.text('Container'), findsOneWidget);
          expect(find.text('Text'), findsOneWidget);

          // Select deeply nested text
          await tester.tap(find.text('Text'));
          await tester.pumpAndSettle();

          expect(selectedId, equals('text-1'));

          // Verify visual selection
          final textItem = tester.widget<WidgetTreeItem>(
            find.byWidgetPredicate(
              (widget) => widget is WidgetTreeItem && widget.nodeId == 'text-1',
            ),
          );
          expect(textItem.isSelected, isTrue);
        },
      );
    });

    group('Selection State Reactivity', () {
      testWidgets('initial selection is rendered correctly', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        // Start with selection
        await tester.pumpWidget(
          buildTestWidget(projectState: state, selectedId: 'container-1'),
        );

        final item = tester.widget<WidgetTreeItem>(
          find.byType(WidgetTreeItem),
        );
        expect(item.isSelected, isTrue);
      });

      testWidgets('click updates selection in provider', (tester) async {
        const container = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const text = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': container, 'text-1': text},
          rootIds: ['container-1', 'text-1'],
        );

        String? selectedId;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              projectProvider.overrideWith(
                (ref) => _TestProjectNotifier(state),
              ),
              widgetRegistryProvider.overrideWith((ref) => registry),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: Consumer(
                  builder: (context, ref, child) {
                    selectedId = ref.watch(selectionProvider);
                    return const WidgetTreePanel();
                  },
                ),
              ),
            ),
          ),
        );

        // Initially no selection
        expect(selectedId, isNull);

        // Click to select
        await tester.tap(find.text('Container'));
        await tester.pumpAndSettle();

        expect(selectedId, equals('container-1'));

        // Verify visual update
        var containerItem = tester.widget<WidgetTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is WidgetTreeItem && widget.nodeId == 'container-1',
          ),
        );
        expect(containerItem.isSelected, isTrue);

        // Select different node
        await tester.tap(find.text('Text'));
        await tester.pumpAndSettle();

        expect(selectedId, equals('text-1'));

        // Verify visual update
        containerItem = tester.widget<WidgetTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is WidgetTreeItem && widget.nodeId == 'container-1',
          ),
        );
        expect(containerItem.isSelected, isFalse);

        final textItem = tester.widget<WidgetTreeItem>(
          find.byWidgetPredicate(
            (widget) => widget is WidgetTreeItem && widget.nodeId == 'text-1',
          ),
        );
        expect(textItem.isSelected, isTrue);
      });
    });
  });
}

/// Test notifier that wraps a preset ProjectState.
class _TestProjectNotifier extends ProjectNotifier {
  _TestProjectNotifier(this._testState) : super();

  final ProjectState _testState;

  @override
  ProjectState get state => _testState;
}
