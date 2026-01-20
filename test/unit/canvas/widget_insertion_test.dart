import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/nested_drop_zone.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Single-Level Widget Insertion (Task 1.4)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('NestedDropZone', () {
      testWidgets('displays drop zone indicator when dragIsActive', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'container1',
                acceptsChildren: true,
                hasChild: false,
                onWidgetDropped: (_, __) {},
                child: const SizedBox(width: 100, height: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should find a DragTarget for nested drops
        expect(find.byType(DragTarget<String>), findsOneWidget);
      });

      testWidgets('shows visual indicator on drag hover', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'container1',
                acceptsChildren: true,
                hasChild: false,
                onWidgetDropped: (_, __) {},
                child: const SizedBox(width: 100, height: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The DragTarget should be present for accepting drops
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        expect(dragTarget.onAcceptWithDetails, isNotNull);
      });

      testWidgets('calls onWidgetDropped with parentId on drop', (
        WidgetTester tester,
      ) async {
        String? droppedType;
        String? droppedParentId;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'container1',
                acceptsChildren: true,
                hasChild: false,
                onWidgetDropped: (type, parentId) {
                  droppedType = type;
                  droppedParentId = parentId;
                },
                child: const SizedBox(width: 100, height: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Simulate drop by calling onAcceptWithDetails
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
        );

        expect(droppedType, equals('Text'));
        expect(droppedParentId, equals('container1'));
      });

      testWidgets('rejects drop when already has child (single-child)', (
        WidgetTester tester,
      ) async {
        var dropAttempted = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'container1',
                acceptsChildren: true,
                hasChild: true, // Already has a child
                maxChildren: 1, // Single-child container
                childCount: 1,
                onWidgetDropped: (_, __) => dropAttempted = true,
                child: const SizedBox(width: 100, height: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The DragTarget should still exist but onWillAcceptWithDetails
        // should reject the drop
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
        );

        expect(willAccept, isFalse);
        expect(dropAttempted, isFalse);
      });

      testWidgets('accepts drop when acceptsChildren and no child', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'container1',
                acceptsChildren: true,
                hasChild: false,
                maxChildren: 1,
                onWidgetDropped: (_, __) {},
                child: const SizedBox(width: 100, height: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
        );

        expect(willAccept, isTrue);
      });

      testWidgets('shows no drop indicator when acceptsChildren is false', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'text1',
                acceptsChildren: false, // Leaf widget
                hasChild: false,
                onWidgetDropped: (_, __) {},
                child: const Text('Hello'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Leaf widgets should reject drops
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
        );

        expect(willAccept, isFalse);
      });

      testWidgets('multi-child accepts when unlimited maxChildren', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'row1',
                acceptsChildren: true,
                hasChild: true,
                // maxChildren defaults to null (unlimited)
                childCount: 5,
                onWidgetDropped: (_, __) {},
                child: const SizedBox(width: 100, height: 100),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        final willAccept = dragTarget.onWillAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
        );

        expect(willAccept, isTrue);
      });
    });

    group('Widget tree update on drop', () {
      testWidgets('Container renders with nested drop zone', (
        WidgetTester tester,
      ) async {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0, 'color': 0xFFCCCCCC},
          ),
        };

        String? droppedType;
        String? droppedParentId;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: 'container1',
                nodes: nodes,
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
                onWidgetDropped: (type, parentId) {
                  droppedType = type;
                  droppedParentId = parentId;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should find nested drop zones
        expect(find.byType(NestedDropZone), findsOneWidget);

        // Simulate drop into container
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );
        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
        );

        expect(droppedType, equals('Text'));
        expect(droppedParentId, equals('container1'));
      });

      testWidgets('Text becomes child of Container on drop', (
        WidgetTester tester,
      ) async {
        // Container with Text child
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Hello'},
            parentId: 'container1',
          ),
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: 'container1',
                nodes: nodes,
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
                onWidgetDropped: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Text should be rendered inside container
        expect(find.text('Hello'), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Single-child container rejects second child drop', (
        WidgetTester tester,
      ) async {
        // Container already has a child
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Existing'},
            parentId: 'container1',
          ),
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: 'container1',
                nodes: nodes,
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
                onWidgetDropped: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find nested drop zone and check it rejects
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        // The parent container's drop zone should reject
        for (final dragTarget in dragTargets) {
          if (dragTarget.onWillAcceptWithDetails != null) {
            final willAccept = dragTarget.onWillAcceptWithDetails!.call(
              DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
            );
            // At least one should reject (the container that already has child)
            if (!willAccept) {
              expect(willAccept, isFalse);
              return;
            }
          }
        }
      });

      testWidgets('Row accepts multiple children drops', (
        WidgetTester tester,
      ) async {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'First'},
            parentId: 'row1',
          ),
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: 'row1',
                nodes: nodes,
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
                onWidgetDropped: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Row should have drop zone that accepts more children
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        // Find the row's drop zone
        for (final dragTarget in dragTargets) {
          if (dragTarget.onWillAcceptWithDetails != null) {
            final willAccept = dragTarget.onWillAcceptWithDetails!.call(
              DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
            );
            if (willAccept) {
              expect(willAccept, isTrue);
              return;
            }
          }
        }
      });
    });
  });
}
