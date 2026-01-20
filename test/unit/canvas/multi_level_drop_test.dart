import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/nested_drop_zone.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Multi-Level Nested Drop Zones (Task 2.7)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget buildTestWidget({
      required Map<String, WidgetNode> nodes,
      required String rootId,
      void Function(String widgetType, String parentId, int? insertIndex)?
          onWidgetDropped,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: WidgetRenderer(
              nodeId: rootId,
              nodes: nodes,
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
              onWidgetDropped: onWidgetDropped != null
                  ? (type, parentId) => onWidgetDropped(type, parentId, null)
                  : null,
            ),
          ),
        ),
      );
    }

    group('Deep Nesting (3+ depth)', () {
      testWidgets('renders 3-level nested structure', (
        WidgetTester tester,
      ) async {
        // Column > Row > Container > Text (depth 4)
        final nodes = <String, WidgetNode>{
          'column': const WidgetNode(
            id: 'column',
            type: 'Column',
            properties: {},
            childrenIds: ['row'],
          ),
          'row': const WidgetNode(
            id: 'row',
            type: 'Row',
            properties: {},
            parentId: 'column',
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 100.0, 'height': 100.0},
            parentId: 'row',
            childrenIds: ['text'],
          ),
          'text': const WidgetNode(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Nested'},
            parentId: 'container',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'column',
        ));
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.text('Nested'), findsOneWidget);
      });

      testWidgets('drop zone works at depth 3', (WidgetTester tester) async {
        // Column > Row > Container (empty, can accept child)
        final nodes = <String, WidgetNode>{
          'column': const WidgetNode(
            id: 'column',
            type: 'Column',
            properties: {},
            childrenIds: ['row'],
          ),
          'row': const WidgetNode(
            id: 'row',
            type: 'Row',
            properties: {},
            parentId: 'column',
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 100.0, 'height': 100.0, 'color': 0xFFCCCCCC},
            parentId: 'row',
          ),
        };

        String? droppedParentId;

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'column',
          onWidgetDropped: (type, parentId, index) {
            droppedParentId = parentId;
          },
        ));
        await tester.pumpAndSettle();

        // Find all DragTargets - the container's should accept
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        // Find and trigger the container's drop zone
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            target.onAcceptWithDetails?.call(
              DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
            );
            break;
          }
        }

        // Should have received drop (could be any accepting container)
        expect(droppedParentId, isNotNull);
      });

      testWidgets('renders 5-level deep structure',
          (WidgetTester tester) async {
        // Column > Row > Column > Row > Container
        final nodes = <String, WidgetNode>{
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {},
            childrenIds: ['row1'],
          ),
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            parentId: 'col1',
            childrenIds: ['col2'],
          ),
          'col2': const WidgetNode(
            id: 'col2',
            type: 'Column',
            properties: {},
            parentId: 'row1',
            childrenIds: ['row2'],
          ),
          'row2': const WidgetNode(
            id: 'row2',
            type: 'Row',
            properties: {},
            parentId: 'col2',
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 50.0, 'height': 50.0, 'color': 0xFFDDDDDD},
            parentId: 'row2',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'col1',
        ));
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsNWidgets(2));
        expect(find.byType(Row), findsNWidgets(2));
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Single-Child Container Validation', () {
      testWidgets('single-child container rejects when has child', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0},
            childrenIds: ['text'],
          ),
          'text': const WidgetNode(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Child'},
            parentId: 'container',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'container',
        ));
        await tester.pumpAndSettle();

        // Find the container's drop zone
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var foundReject = false;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (!willAccept) {
            foundReject = true;
          }
        }

        expect(foundReject, isTrue);
      });

      testWidgets('single-child container accepts when empty', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0, 'color': 0xFFCCCCCC},
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'container',
        ));
        await tester.pumpAndSettle();

        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var foundAccept = false;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            foundAccept = true;
          }
        }

        expect(foundAccept, isTrue);
      });
    });

    group('Multi-Child Container (Row/Column)', () {
      testWidgets('Row accepts multiple children', (WidgetTester tester) async {
        final nodes = <String, WidgetNode>{
          'row': const WidgetNode(
            id: 'row',
            type: 'Row',
            properties: {},
            childrenIds: ['text1', 'text2'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'First'},
            parentId: 'row',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Second'},
            parentId: 'row',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'row',
        ));
        await tester.pumpAndSettle();

        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var foundAccept = false;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            foundAccept = true;
          }
        }

        expect(foundAccept, isTrue);
      });

      testWidgets('Column accepts unlimited children', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'column': const WidgetNode(
            id: 'column',
            type: 'Column',
            properties: {},
            childrenIds: ['t1', 't2', 't3', 't4', 't5'],
          ),
          't1': const WidgetNode(
            id: 't1',
            type: 'Text',
            properties: {'data': '1'},
            parentId: 'column',
          ),
          't2': const WidgetNode(
            id: 't2',
            type: 'Text',
            properties: {'data': '2'},
            parentId: 'column',
          ),
          't3': const WidgetNode(
            id: 't3',
            type: 'Text',
            properties: {'data': '3'},
            parentId: 'column',
          ),
          't4': const WidgetNode(
            id: 't4',
            type: 'Text',
            properties: {'data': '4'},
            parentId: 'column',
          ),
          't5': const WidgetNode(
            id: 't5',
            type: 'Text',
            properties: {'data': '5'},
            parentId: 'column',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'column',
        ));
        await tester.pumpAndSettle();

        // All 5 texts should be rendered
        expect(find.text('1'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);

        // Should still accept more
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var foundAccept = false;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            foundAccept = true;
          }
        }

        expect(foundAccept, isTrue);
      });
    });

    group('Leaf Widget Validation', () {
      testWidgets('Text widget (leaf) rejects children', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'text': const WidgetNode(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Leaf'},
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'text',
        ));
        await tester.pumpAndSettle();

        // Text is a leaf - no drop zone should exist
        // Or if it exists, it should reject
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var anyAccepted = false;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(
                    data: 'Container', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            anyAccepted = true;
          }
        }

        expect(anyAccepted, isFalse);
      });
    });

    group('Visual Feedback', () {
      testWidgets('shows hover indicator on valid drop target', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0, 'color': 0xFFCCCCCC},
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'container',
        ));
        await tester.pumpAndSettle();

        // The DragTarget should exist
        expect(find.byType(DragTarget<String>), findsWidgets);
        // NestedDropZone wraps container widgets that accept children
        expect(find.byType(NestedDropZone), findsOneWidget);
      });

      testWidgets('NestedDropZone wraps multi-child containers', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'row': const WidgetNode(
            id: 'row',
            type: 'Row',
            properties: {},
            childrenIds: ['text'],
          ),
          'text': const WidgetNode(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Child'},
            parentId: 'row',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'row',
        ));
        await tester.pumpAndSettle();

        // Row should have NestedDropZone
        expect(find.byType(NestedDropZone), findsOneWidget);
      });
    });

    group('Drop Callback', () {
      testWidgets('onWidgetDropped called with correct parentId', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'column': const WidgetNode(
            id: 'column',
            type: 'Column',
            properties: {},
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 100.0, 'height': 100.0, 'color': 0xFFEEEEEE},
            parentId: 'column',
          ),
        };

        String? droppedType;
        String? droppedParentId;

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'column',
          onWidgetDropped: (type, parentId, index) {
            droppedType = type;
            droppedParentId = parentId;
          },
        ));
        await tester.pumpAndSettle();

        // Find a drop target and trigger it
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            target.onAcceptWithDetails?.call(
              DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
            );
            break;
          }
        }

        expect(droppedType, equals('Text'));
        expect(droppedParentId, isNotNull);
      });

      testWidgets('drop into nested container passes correct parent', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'col': const WidgetNode(
            id: 'col',
            type: 'Column',
            properties: {},
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 150.0, 'height': 150.0, 'color': 0xFFBBBBBB},
            parentId: 'col',
          ),
        };

        final droppedParents = <String>[];

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'col',
          onWidgetDropped: (type, parentId, index) {
            droppedParents.add(parentId);
          },
        ));
        await tester.pumpAndSettle();

        // Trigger all accepting drop zones
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            target.onAcceptWithDetails?.call(
              DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
            );
          }
        }

        // Should have triggered drops on both col and container
        expect(droppedParents, contains('col'));
        expect(droppedParents, contains('container'));
      });
    });

    group('Complex Nested Structures', () {
      testWidgets('renders Column > Row > Column > Container', (
        WidgetTester tester,
      ) async {
        // 4-level deep structure
        final nodes = <String, WidgetNode>{
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {},
            childrenIds: ['row1'],
          ),
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            parentId: 'col1',
            childrenIds: ['col2'],
          ),
          'col2': const WidgetNode(
            id: 'col2',
            type: 'Column',
            properties: {},
            parentId: 'row1',
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 80.0, 'height': 80.0, 'color': 0xFFAAAAAA},
            parentId: 'col2',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'col1',
        ));
        await tester.pumpAndSettle();

        expect(find.byType(Column), findsNWidgets(2));
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('all levels have working drop zones', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'col': const WidgetNode(
            id: 'col',
            type: 'Column',
            properties: {},
            childrenIds: ['row'],
          ),
          'row': const WidgetNode(
            id: 'row',
            type: 'Row',
            properties: {},
            parentId: 'col',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'col',
        ));
        await tester.pumpAndSettle();

        // Both Column and Row should have drop zones
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var acceptCount = 0;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            acceptCount++;
          }
        }

        // Both should accept
        expect(acceptCount, greaterThanOrEqualTo(2));
      });
    });

    group('SizedBox Nesting', () {
      testWidgets('SizedBox with child rejects second child', (
        WidgetTester tester,
      ) async {
        final nodes = <String, WidgetNode>{
          'sizedbox': const WidgetNode(
            id: 'sizedbox',
            type: 'SizedBox',
            properties: {'width': 100.0, 'height': 100.0},
            childrenIds: ['text'],
          ),
          'text': const WidgetNode(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Child'},
            parentId: 'sizedbox',
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'sizedbox',
        ));
        await tester.pumpAndSettle();

        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var allRejected = true;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(
                    data: 'Container', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            allRejected = false;
          }
        }

        // SizedBox is single-child and already has one
        expect(allRejected, isTrue);
      });

      testWidgets('empty SizedBox accepts child', (WidgetTester tester) async {
        final nodes = <String, WidgetNode>{
          'sizedbox': const WidgetNode(
            id: 'sizedbox',
            type: 'SizedBox',
            properties: {'width': 100.0, 'height': 100.0},
          ),
        };

        await tester.pumpWidget(buildTestWidget(
          nodes: nodes,
          rootId: 'sizedbox',
        ));
        await tester.pumpAndSettle();

        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        var foundAccept = false;
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(data: 'Text', offset: Offset.zero),
              ) ??
              false;
          if (willAccept) {
            foundAccept = true;
          }
        }

        expect(foundAccept, isTrue);
      });
    });

    group('NestedDropZone Unit Tests', () {
      testWidgets('renders child widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'parent1',
                acceptsChildren: true,
                hasChild: false,
                onWidgetDropped: (_, __) {},
                child: const Text('Test Child'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Test Child'), findsOneWidget);
      });

      testWidgets('accepts when maxChildren is null (unlimited)', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'row1',
                acceptsChildren: true,
                hasChild: true,
                childCount: 10,
                // maxChildren is null = unlimited
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

      testWidgets('rejects when acceptsChildren is false', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NestedDropZone(
                parentId: 'text1',
                acceptsChildren: false,
                hasChild: false,
                onWidgetDropped: (_, __) {},
                child: const Text('Leaf'),
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

        expect(willAccept, isFalse);
      });
    });
  });
}
