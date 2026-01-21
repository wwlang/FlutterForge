import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/tree/draggable_tree_item.dart';
import 'package:flutter_forge/features/tree/widget_tree_panel.dart';
import 'package:flutter_forge/providers/providers.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Tree Panel UI (Task 2.3)', () {
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

    group('Empty State', () {
      testWidgets('shows empty state when no widgets', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(projectState: const ProjectState()),
        );

        expect(find.text('No widgets'), findsOneWidget);
        expect(find.byType(DraggableTreeItem), findsNothing);
      });

      testWidgets('shows helper text in empty state', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(projectState: const ProjectState()),
        );

        expect(
          find.text('Drag from palette'),
          findsOneWidget,
        );
      });
    });

    group('Tree Rendering', () {
      testWidgets('displays single root widget', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: state));

        expect(find.text('Container'), findsOneWidget);
        expect(find.byType(DraggableTreeItem), findsOneWidget);
      });

      testWidgets('displays multiple root widgets', (tester) async {
        const node1 = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const node2 = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node1, 'text-1': node2},
          rootIds: ['container-1', 'text-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: state));

        expect(find.text('Container'), findsOneWidget);
        expect(find.text('Text'), findsOneWidget);
        expect(find.byType(DraggableTreeItem), findsNWidgets(2));
      });

      testWidgets('displays nested widgets with indentation', (tester) async {
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

        await tester.pumpWidget(buildTestWidget(projectState: state));

        expect(find.byType(DraggableTreeItem), findsNWidgets(2));

        // Child should be indented (check depth)
        final childItem = tester.widget<DraggableTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is DraggableTreeItem && widget.nodeId == 'text-1',
          ),
        );
        expect(childItem.depth, equals(1));
      });

      testWidgets('displays deeply nested structure', (tester) async {
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

        await tester.pumpWidget(buildTestWidget(projectState: state));

        expect(find.byType(DraggableTreeItem), findsNWidgets(3));

        // Check depths
        final rootItem = tester.widget<DraggableTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is DraggableTreeItem && widget.nodeId == 'column-1',
          ),
        );
        expect(rootItem.depth, equals(0));

        final containerItem = tester.widget<DraggableTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is DraggableTreeItem && widget.nodeId == 'container-1',
          ),
        );
        expect(containerItem.depth, equals(1));

        final textItem = tester.widget<DraggableTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is DraggableTreeItem && widget.nodeId == 'text-1',
          ),
        );
        expect(textItem.depth, equals(2));
      });
    });

    group('Widget Icons', () {
      testWidgets('displays widget type icon', (tester) async {
        const node = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node},
          rootIds: ['container-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: state));

        // Container should have a crop_square icon
        expect(find.byIcon(Icons.crop_square), findsOneWidget);
      });

      testWidgets(
        'displays different icons for different widget types',
        (tester) async {
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
          const row = WidgetNode(
            id: 'row-1',
            type: 'Row',
            properties: {},
          );
          const state = ProjectState(
            nodes: {
              'container-1': container,
              'text-1': text,
              'row-1': row,
            },
            rootIds: ['container-1', 'text-1', 'row-1'],
          );

          await tester.pumpWidget(buildTestWidget(projectState: state));

          // Each widget type should have its own icon
          expect(find.byIcon(Icons.crop_square), findsOneWidget); // Container
          expect(find.byIcon(Icons.text_fields), findsOneWidget); // Text
          expect(find.byIcon(Icons.view_column), findsOneWidget); // Row
        },
      );
    });

    group('Expand/Collapse', () {
      testWidgets('parent with children shows expand arrow', (tester) async {
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

        await tester.pumpWidget(buildTestWidget(projectState: state));

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });

      testWidgets('leaf widget has no expand arrow', (tester) async {
        const node = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'text-1': node},
          rootIds: ['text-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: state));

        expect(find.byIcon(Icons.keyboard_arrow_down), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
      });

      testWidgets('tapping arrow collapses children', (tester) async {
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

        await tester.pumpWidget(buildTestWidget(projectState: state));

        // Initially expanded - child visible
        expect(find.text('Text'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

        // Tap to collapse
        await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
        await tester.pumpAndSettle();

        // Child should be hidden
        expect(find.text('Text'), findsNothing);
        expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
      });

      testWidgets('tapping collapsed arrow expands children', (tester) async {
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

        await tester.pumpWidget(buildTestWidget(projectState: state));

        // Collapse first
        await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
        await tester.pumpAndSettle();

        // Now expand
        await tester.tap(find.byIcon(Icons.keyboard_arrow_right));
        await tester.pumpAndSettle();

        // Child should be visible again
        expect(find.text('Text'), findsOneWidget);
        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });
    });

    group('Selection Highlight', () {
      testWidgets('selected widget has highlight', (tester) async {
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

        // Find the tree item and check its selected state
        final item = tester.widget<DraggableTreeItem>(
          find.byType(DraggableTreeItem),
        );
        expect(item.isSelected, isTrue);
      });

      testWidgets('non-selected widget has no highlight', (tester) async {
        const node1 = WidgetNode(
          id: 'container-1',
          type: 'Container',
          properties: {},
        );
        const node2 = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: {},
        );
        const state = ProjectState(
          nodes: {'container-1': node1, 'text-1': node2},
          rootIds: ['container-1', 'text-1'],
        );

        await tester.pumpWidget(
          buildTestWidget(
            projectState: state,
            selectedId: 'container-1',
          ),
        );

        // Container should be selected
        final containerItem = tester.widget<DraggableTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is DraggableTreeItem && widget.nodeId == 'container-1',
          ),
        );
        expect(containerItem.isSelected, isTrue);

        // Text should not be selected
        final textItem = tester.widget<DraggableTreeItem>(
          find.byWidgetPredicate(
            (widget) =>
                widget is DraggableTreeItem && widget.nodeId == 'text-1',
          ),
        );
        expect(textItem.isSelected, isFalse);
      });
    });

    group('Panel Header', () {
      testWidgets('displays "Widget Tree" header', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(projectState: const ProjectState()),
        );

        expect(find.text('Widget Tree'), findsOneWidget);
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
