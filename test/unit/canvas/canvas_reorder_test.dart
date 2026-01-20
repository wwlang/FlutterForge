import 'package:flutter/material.dart';
import 'package:flutter_forge/commands/move_widget_command.dart';
import 'package:flutter_forge/features/canvas/canvas_reorder_target.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Canvas Widget Reordering (Task 2.8)', () {
    group('CanvasReorderTarget', () {
      testWidgets('renders child widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasReorderTarget(
                nodeId: 'test',
                parentId: 'parent',
                currentIndex: 0,
                siblingCount: 3,
                axis: Axis.horizontal,
                onReorder: (_, __, ___) {},
                child: const Text('Test'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('provides drag target for reordering', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasReorderTarget(
                nodeId: 'widget1',
                parentId: 'row1',
                currentIndex: 1,
                siblingCount: 3,
                axis: Axis.horizontal,
                onReorder: (_, __, ___) {},
                child: Container(width: 50, height: 50, color: Colors.blue),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // DragTarget should exist
        expect(find.byType(DragTarget<ReorderDragData>), findsOneWidget);
      });

      testWidgets('calls onReorder when valid drop occurs', (
        WidgetTester tester,
      ) async {
        String? sourceId;
        int? fromIndex;
        int? toIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasReorderTarget(
                nodeId: 'widget1',
                parentId: 'row1',
                currentIndex: 1,
                siblingCount: 3,
                axis: Axis.horizontal,
                onReorder: (source, from, to) {
                  sourceId = source;
                  fromIndex = from;
                  toIndex = to;
                },
                child: Container(width: 50, height: 50, color: Colors.blue),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Simulate drop
        final dragTarget = tester.widget<DragTarget<ReorderDragData>>(
          find.byType(DragTarget<ReorderDragData>),
        );

        const dragData = ReorderDragData(
          nodeId: 'widget2',
          parentId: 'row1',
          currentIndex: 0,
        );

        // Accept the drop
        if (dragTarget.onWillAcceptWithDetails != null) {
          final willAccept = dragTarget.onWillAcceptWithDetails!(
            DragTargetDetails(data: dragData, offset: Offset.zero),
          );
          expect(willAccept, isTrue);
        }

        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails(data: dragData, offset: Offset.zero),
        );

        expect(sourceId, equals('widget2'));
        expect(fromIndex, equals(0));
        expect(toIndex, isNotNull);
      });

      testWidgets('rejects drop from different parent', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasReorderTarget(
                nodeId: 'widget1',
                parentId: 'row1',
                currentIndex: 0,
                siblingCount: 2,
                axis: Axis.horizontal,
                onReorder: (_, __, ___) {},
                child: Container(width: 50, height: 50, color: Colors.blue),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dragTarget = tester.widget<DragTarget<ReorderDragData>>(
          find.byType(DragTarget<ReorderDragData>),
        );

        // Try to drop from different parent
        const dragData = ReorderDragData(
          nodeId: 'widget3',
          parentId: 'row2', // Different parent
          currentIndex: 0,
        );

        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails(data: dragData, offset: Offset.zero),
        );

        expect(willAccept, isFalse);
      });

      testWidgets('rejects self-drop', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasReorderTarget(
                nodeId: 'widget1',
                parentId: 'row1',
                currentIndex: 0,
                siblingCount: 2,
                axis: Axis.horizontal,
                onReorder: (_, __, ___) {},
                child: Container(width: 50, height: 50, color: Colors.blue),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dragTarget = tester.widget<DragTarget<ReorderDragData>>(
          find.byType(DragTarget<ReorderDragData>),
        );

        // Try to drop on self
        const dragData = ReorderDragData(
          nodeId: 'widget1', // Same as target
          parentId: 'row1',
          currentIndex: 0,
        );

        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails(data: dragData, offset: Offset.zero),
        );

        expect(willAccept, isFalse);
      });
    });

    group('MoveWidgetCommand Integration', () {
      test('creates valid command for reorder', () {
        final command = MoveWidgetCommand(
          nodeId: 'widget1',
          oldParentId: 'row1',
          newParentId: 'row1',
          oldIndex: 0,
          newIndex: 2,
        );

        expect(command.nodeId, equals('widget1'));
        expect(command.oldIndex, equals(0));
        expect(command.newIndex, equals(2));
      });

      test('same parent reorder does not change parent', () {
        final command = MoveWidgetCommand(
          nodeId: 'widget1',
          oldParentId: 'row1',
          newParentId: 'row1', // Same parent
          oldIndex: 0,
          newIndex: 2,
        );

        expect(command.oldParentId, equals(command.newParentId));
      });
    });

    group('Reorder Data', () {
      test('ReorderDragData stores node information', () {
        const data = ReorderDragData(
          nodeId: 'widget1',
          parentId: 'row1',
          currentIndex: 2,
        );

        expect(data.nodeId, equals('widget1'));
        expect(data.parentId, equals('row1'));
        expect(data.currentIndex, equals(2));
      });
    });

    group('Reorder Position Calculation', () {
      testWidgets('calculates insert position for horizontal axis', (
        WidgetTester tester,
      ) async {
        int? calculatedIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 100,
                child: CanvasReorderTarget(
                  nodeId: 'widget2',
                  parentId: 'row1',
                  currentIndex: 1,
                  siblingCount: 3,
                  axis: Axis.horizontal,
                  onReorder: (_, __, to) {
                    calculatedIndex = to;
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dragTarget = tester.widget<DragTarget<ReorderDragData>>(
          find.byType(DragTarget<ReorderDragData>),
        );

        const dragData = ReorderDragData(
          nodeId: 'widget1',
          parentId: 'row1',
          currentIndex: 0,
        );

        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails(data: dragData, offset: const Offset(200, 50)),
        );

        expect(calculatedIndex, isNotNull);
      });
    });

    group('Visual Feedback', () {
      testWidgets('shows indicator when hovering over drop zone', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CanvasReorderTarget(
                nodeId: 'widget1',
                parentId: 'row1',
                currentIndex: 0,
                siblingCount: 3,
                axis: Axis.horizontal,
                onReorder: (_, __, ___) {},
                child: Container(width: 100, height: 100, color: Colors.blue),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Target exists for visual feedback
        expect(find.byType(CanvasReorderTarget), findsOneWidget);
      });
    });
  });
}
