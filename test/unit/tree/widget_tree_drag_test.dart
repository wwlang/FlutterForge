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
  group('Widget Tree Drag Reorder (Task 2.5)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget createTestApp({
      required ProjectState initialState,
      String? selectedId,
    }) {
      return ProviderScope(
        overrides: [
          projectProvider.overrideWith((ref) {
            return ProjectNotifier()..setState(initialState);
          }),
          selectionProvider.overrideWith((ref) => selectedId),
          widgetRegistryProvider.overrideWithValue(registry),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 600,
              child: WidgetTreePanel(),
            ),
          ),
        ),
      );
    }

    /// Creates a project state with Column having children [A, B, C].
    ProjectState createColumnWithThreeChildren() {
      return const ProjectState(
        nodes: {
          'column1': WidgetNode(
            id: 'column1',
            type: 'Column',
            properties: {},
            childrenIds: ['text_a', 'text_b', 'text_c'],
          ),
          'text_a': WidgetNode(
            id: 'text_a',
            type: 'Text',
            parentId: 'column1',
            properties: {'data': 'A'},
          ),
          'text_b': WidgetNode(
            id: 'text_b',
            type: 'Text',
            parentId: 'column1',
            properties: {'data': 'B'},
          ),
          'text_c': WidgetNode(
            id: 'text_c',
            type: 'Text',
            parentId: 'column1',
            properties: {'data': 'C'},
          ),
        },
        rootIds: ['column1'],
      );
    }

    /// Creates a project state with Row and Column as siblings.
    ProjectState createRowAndColumnSiblings() {
      return const ProjectState(
        nodes: {
          'root': WidgetNode(
            id: 'root',
            type: 'Column',
            properties: {},
            childrenIds: ['row1', 'column1'],
          ),
          'row1': WidgetNode(
            id: 'row1',
            type: 'Row',
            parentId: 'root',
            properties: {},
            childrenIds: ['text1'],
          ),
          'text1': WidgetNode(
            id: 'text1',
            type: 'Text',
            parentId: 'row1',
            properties: {'data': 'Hello'},
          ),
          'column1': WidgetNode(
            id: 'column1',
            type: 'Column',
            parentId: 'root',
            properties: {},
          ),
        },
        rootIds: ['root'],
      );
    }

    group('DraggableTreeItem Rendering', () {
      testWidgets('renders draggable tree items with keys', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // All items should have keys
        expect(find.byKey(const ValueKey('column1')), findsOneWidget);
        expect(find.byKey(const ValueKey('text_a')), findsOneWidget);
        expect(find.byKey(const ValueKey('text_b')), findsOneWidget);
        expect(find.byKey(const ValueKey('text_c')), findsOneWidget);
      });

      testWidgets('displays widget types correctly', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        expect(find.text('Column'), findsOneWidget);
        expect(find.text('Text'), findsNWidgets(3)); // A, B, C
      });

      testWidgets('items are draggable (LongPressDraggable)', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // Verify LongPressDraggable is in the tree
        expect(find.byType(LongPressDraggable<TreeDragData>), findsNWidgets(4));
      });
    });

    group('Drag Feedback', () {
      testWidgets('long press drag shows feedback widget', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        final draggableItem = find.byKey(const ValueKey('text_b'));

        // Long press and drag
        final gesture = await tester.startGesture(
          tester.getCenter(draggableItem),
        );
        await tester
            .pump(const Duration(milliseconds: 500)); // Long press duration
        await gesture.moveBy(const Offset(0, 50));
        await tester.pump();

        // Drag feedback should be visible
        expect(find.byKey(const Key('drag_feedback')), findsOneWidget);

        await gesture.cancel();
      });
    });

    group('Drop Validation - Unit Tests', () {
      testWidgets('rejects drop on self', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // Get the DraggableTreeItem state to test validation
        final draggable = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text_b')),
        );

        const data = TreeDragData(
          nodeId: 'text_b',
          parentId: 'column1',
          widgetType: 'Text',
          currentIndex: 1,
        );

        final validation = draggable.onDropValidation(data, 'text_b');

        expect(validation.isValid, isFalse);
        expect(validation.rejectionReason, contains('self'));
      });

      testWidgets('rejects drop on descendant', (tester) async {
        // Create nested structure: Container > Column > Text
        const state = ProjectState(
          nodes: {
            'container': WidgetNode(
              id: 'container',
              type: 'Container',
              properties: {},
              childrenIds: ['column'],
            ),
            'column': WidgetNode(
              id: 'column',
              type: 'Column',
              parentId: 'container',
              properties: {},
              childrenIds: ['text'],
            ),
            'text': WidgetNode(
              id: 'text',
              type: 'Text',
              parentId: 'column',
              properties: {'data': 'Hello'},
            ),
          },
          rootIds: ['container'],
        );

        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        final draggable = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('container')),
        );

        const data = TreeDragData(
          nodeId: 'container',
          parentId: null,
          widgetType: 'Container',
          currentIndex: 0,
        );

        // Try to drop container onto its descendant text
        final validation = draggable.onDropValidation(data, 'text');

        expect(validation.isValid, isFalse);
        expect(validation.rejectionReason, contains('descendant'));
      });

      testWidgets('rejects single-child parent with existing child',
          (tester) async {
        const state = ProjectState(
          nodes: {
            'column': WidgetNode(
              id: 'column',
              type: 'Column',
              properties: {},
              childrenIds: ['container', 'text_outside'],
            ),
            'container': WidgetNode(
              id: 'container',
              type: 'Container',
              parentId: 'column',
              properties: {},
              childrenIds: ['text_inside'],
            ),
            'text_inside': WidgetNode(
              id: 'text_inside',
              type: 'Text',
              parentId: 'container',
              properties: {'data': 'Inside'},
            ),
            'text_outside': WidgetNode(
              id: 'text_outside',
              type: 'Text',
              parentId: 'column',
              properties: {'data': 'Outside'},
            ),
          },
          rootIds: ['column'],
        );

        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        final draggable = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text_outside')),
        );

        const data = TreeDragData(
          nodeId: 'text_outside',
          parentId: 'column',
          widgetType: 'Text',
          currentIndex: 1,
        );

        // Try to drop into container (which already has child)
        final validation = draggable.onDropValidation(data, 'container');

        expect(validation.isValid, isFalse);
        expect(validation.rejectionReason, contains('already has a child'));
      });

      testWidgets('accepts drop on valid multi-child parent', (tester) async {
        final state = createRowAndColumnSiblings();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        final draggable = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text1')),
        );

        const data = TreeDragData(
          nodeId: 'text1',
          parentId: 'row1',
          widgetType: 'Text',
          currentIndex: 0,
        );

        // Drop into empty Column (valid target)
        final validation = draggable.onDropValidation(data, 'column1');

        expect(validation.isValid, isTrue);
        expect(validation.targetParentId, 'column1');
        expect(validation.targetIndex, 0);
      });

      testWidgets('rejects drop on leaf widget', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        final draggable = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text_a')),
        );

        const data = TreeDragData(
          nodeId: 'text_a',
          parentId: 'column1',
          widgetType: 'Text',
          currentIndex: 0,
        );

        // Try to drop onto another Text (leaf widget, can't have children)
        final validation = draggable.onDropValidation(data, 'text_b');

        expect(validation.isValid, isFalse);
        expect(validation.rejectionReason, contains('cannot have children'));
      });
    });

    group('Selection Preservation', () {
      testWidgets('clicking item still selects it', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        final textB = find.byKey(const ValueKey('text_b'));
        await tester.tap(textB);
        await tester.pumpAndSettle();

        final container = tester.element(find.byType(WidgetTreePanel));
        final selectedId =
            ProviderScope.containerOf(container).read(selectionProvider);

        expect(selectedId, 'text_b');
      });

      testWidgets('selection visual feedback still works', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(
          createTestApp(initialState: state, selectedId: 'text_a'),
        );
        await tester.pumpAndSettle();

        // The selected item should have visual feedback
        final item = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text_a')),
        );
        expect(item.isSelected, isTrue);
      });
    });

    group('Tree Structure', () {
      testWidgets('maintains expand/collapse functionality', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // Initially all children visible
        expect(find.text('Text'), findsNWidgets(3));

        // Find and tap the collapse arrow on Column
        final collapseArrow = find.descendant(
          of: find.byKey(const ValueKey('column1')),
          matching: find.byIcon(Icons.keyboard_arrow_down),
        );
        await tester.tap(collapseArrow);
        await tester.pumpAndSettle();

        // After collapse, children hidden
        expect(find.text('Text'), findsNothing);
      });

      testWidgets('shows correct indentation for nested items', (tester) async {
        final state = createRowAndColumnSiblings();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // Get depth from DraggableTreeItem
        final rootItem = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('root')),
        );
        final rowItem = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('row1')),
        );
        final textItem = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text1')),
        );

        expect(rootItem.depth, 0);
        expect(rowItem.depth, 1);
        expect(textItem.depth, 2);
      });
    });

    group('Drag Data', () {
      testWidgets('TreeDragData contains correct information', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // Verify the DraggableTreeItem passes correct data
        final item = tester.widget<DraggableTreeItem>(
          find.byKey(const ValueKey('text_b')),
        );

        expect(item.nodeId, 'text_b');
        expect(item.parentId, 'column1');
        expect(item.widgetType, 'Text');
        expect(item.currentIndex, 1);
      });
    });

    group('Drop Target Visual Feedback', () {
      testWidgets('DragTarget is present in tree items', (tester) async {
        final state = createColumnWithThreeChildren();
        await tester.pumpWidget(createTestApp(initialState: state));
        await tester.pumpAndSettle();

        // Verify DragTarget widgets are present
        expect(find.byType(DragTarget<TreeDragData>), findsNWidgets(4));
      });
    });
  });
}
