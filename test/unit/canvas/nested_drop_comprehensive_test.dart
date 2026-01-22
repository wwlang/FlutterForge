import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/design_canvas.dart';
import 'package:flutter_forge/features/canvas/nested_drop_zone.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Comprehensive tests for nested drop functionality covering:
/// - Bug fix verification (TextField into Container)
/// - Parent-child constraint validation (Expanded/Flexible)
/// - Widget tree relationship verification
/// - Full end-to-end nested drop flow
///
/// Related Journey: docs/journeys/editor/design-canvas.md
/// - Stage 2: Nested Widget Insertion
/// - AC: Drop into single-child container, parent-child compatibility
void main() {
  group('Nested Drop Bug Fix Verification', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('TextField into Container (Bug Fix)', () {
      testWidgets(
        'onWidgetDropped is called when TextField dropped into Container',
        (WidgetTester tester) async {
          String? droppedType;
          String? droppedParentId;

          // Empty Container (accepts children)
          final nodes = {
            'container1': const WidgetNode(
              id: 'container1',
              type: 'Container',
              properties: {
                'width': 200.0,
                'height': 200.0,
                'color': 0xFFCCCCCC,
              },
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
                  onWidgetDropped: (type, parentId) {
                    droppedType = type;
                    droppedParentId = parentId;
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          // Find the DragTarget inside NestedDropZone
          final dragTarget = tester.widget<DragTarget<String>>(
            find.byType(DragTarget<String>),
          );

          // Simulate dropping TextField into Container
          dragTarget.onAcceptWithDetails?.call(
            DragTargetDetails<String>(data: 'TextField', offset: Offset.zero),
          );

          // Verify callback was called with correct values
          expect(droppedType, equals('TextField'));
          expect(droppedParentId, equals('container1'));
        },
      );

      testWidgets(
        'Container with TextField child renders correctly',
        (WidgetTester tester) async {
          // Container with TextField as child - simulating state after drop
          final nodes = {
            'container1': const WidgetNode(
              id: 'container1',
              type: 'Container',
              properties: {'width': 300.0, 'height': 200.0},
              childrenIds: ['textfield1'],
            ),
            'textfield1': const WidgetNode(
              id: 'textfield1',
              type: 'TextField',
              properties: {'labelText': 'Test Input'},
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

          // TextField should be rendered inside Container
          expect(find.byType(TextField), findsOneWidget);
          expect(find.text('Test Input'), findsOneWidget);
        },
      );

      testWidgets(
        'Container with TextField child rejects second child',
        (WidgetTester tester) async {
          // Container already has TextField child
          final nodes = {
            'container1': const WidgetNode(
              id: 'container1',
              type: 'Container',
              properties: {'width': 300.0, 'height': 200.0},
              childrenIds: ['textfield1'],
            ),
            'textfield1': const WidgetNode(
              id: 'textfield1',
              type: 'TextField',
              properties: {'labelText': 'Existing Input'},
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

          // Find DragTargets
          final dragTargets = tester.widgetList<DragTarget<String>>(
            find.byType(DragTarget<String>),
          );

          // Container's drop zone should reject another drop
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

          expect(
            foundReject,
            isTrue,
            reason: 'Container should reject second child',
          );
        },
      );
    });

    group('Other Input Widgets into Container', () {
      testWidgets(
        'Checkbox can be dropped into Container',
        (WidgetTester tester) async {
          String? droppedType;

          final nodes = {
            'container1': const WidgetNode(
              id: 'container1',
              type: 'Container',
              properties: {
                'width': 100.0,
                'height': 100.0,
                'color': 0xFFEEEEEE,
              },
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
                  onWidgetDropped: (type, _) {
                    droppedType = type;
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final dragTarget = tester.widget<DragTarget<String>>(
            find.byType(DragTarget<String>),
          );

          dragTarget.onAcceptWithDetails?.call(
            DragTargetDetails<String>(data: 'Checkbox', offset: Offset.zero),
          );

          expect(droppedType, equals('Checkbox'));
        },
      );

      testWidgets(
        'Switch can be dropped into Container',
        (WidgetTester tester) async {
          String? droppedType;

          final nodes = {
            'container1': const WidgetNode(
              id: 'container1',
              type: 'Container',
              properties: {
                'width': 100.0,
                'height': 100.0,
                'color': 0xFFEEEEEE,
              },
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
                  onWidgetDropped: (type, _) {
                    droppedType = type;
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final dragTarget = tester.widget<DragTarget<String>>(
            find.byType(DragTarget<String>),
          );

          dragTarget.onAcceptWithDetails?.call(
            DragTargetDetails<String>(data: 'Switch', offset: Offset.zero),
          );

          expect(droppedType, equals('Switch'));
        },
      );

      testWidgets(
        'Slider can be dropped into Container',
        (WidgetTester tester) async {
          String? droppedType;

          final nodes = {
            'container1': const WidgetNode(
              id: 'container1',
              type: 'Container',
              properties: {
                'width': 200.0,
                'height': 100.0,
                'color': 0xFFEEEEEE,
              },
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
                  onWidgetDropped: (type, _) {
                    droppedType = type;
                  },
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          final dragTarget = tester.widget<DragTarget<String>>(
            find.byType(DragTarget<String>),
          );

          dragTarget.onAcceptWithDetails?.call(
            DragTargetDetails<String>(data: 'Slider', offset: Offset.zero),
          );

          expect(droppedType, equals('Slider'));
        },
      );
    });
  });

  group('Parent-Child Constraint Validation', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('Expanded requires Flex parent', () {
      test('canAcceptChild returns false for Expanded in Container', () {
        // Container is NOT a Flex widget
        final canAccept = registry.canAcceptChild('Container', 'Expanded');
        expect(
          canAccept,
          isFalse,
          reason: 'Expanded requires Flex parent, Container is not Flex',
        );
      });

      test('canAcceptChild returns true for Expanded in Row', () {
        final canAccept = registry.canAcceptChild('Row', 'Expanded');
        expect(
          canAccept,
          isTrue,
          reason: 'Row is a Flex widget, should accept Expanded',
        );
      });

      test('canAcceptChild returns true for Expanded in Column', () {
        final canAccept = registry.canAcceptChild('Column', 'Expanded');
        expect(
          canAccept,
          isTrue,
          reason: 'Column is a Flex widget, should accept Expanded',
        );
      });

      test('canAcceptChild returns false for Expanded in Stack', () {
        final canAccept = registry.canAcceptChild('Stack', 'Expanded');
        expect(canAccept, isFalse, reason: 'Stack is NOT a Flex widget');
      });
    });

    group('Flexible requires Flex parent', () {
      test('canAcceptChild returns false for Flexible in Container', () {
        final canAccept = registry.canAcceptChild('Container', 'Flexible');
        expect(canAccept, isFalse);
      });

      test('canAcceptChild returns true for Flexible in Row', () {
        final canAccept = registry.canAcceptChild('Row', 'Flexible');
        expect(canAccept, isTrue);
      });

      test('canAcceptChild returns true for Flexible in Column', () {
        final canAccept = registry.canAcceptChild('Column', 'Flexible');
        expect(canAccept, isTrue);
      });

      test('canAcceptChild returns false for Flexible in Card', () {
        final canAccept = registry.canAcceptChild('Card', 'Flexible');
        expect(canAccept, isFalse);
      });
    });

    group('Spacer requires Flex parent', () {
      test('canAcceptChild returns false for Spacer in Container', () {
        final canAccept = registry.canAcceptChild('Container', 'Spacer');
        expect(canAccept, isFalse);
      });

      test('canAcceptChild returns true for Spacer in Row', () {
        final canAccept = registry.canAcceptChild('Row', 'Spacer');
        expect(canAccept, isTrue);
      });

      test('canAcceptChild returns true for Spacer in Column', () {
        final canAccept = registry.canAcceptChild('Column', 'Spacer');
        expect(canAccept, isTrue);
      });

      test('canAcceptChild returns false for Spacer in Scaffold', () {
        final canAccept = registry.canAcceptChild('Scaffold', 'Spacer');
        expect(canAccept, isFalse);
      });
    });

    group('Widgets without parent constraints', () {
      test('TextField can go in any accepting parent', () {
        expect(registry.canAcceptChild('Container', 'TextField'), isTrue);
        expect(registry.canAcceptChild('Row', 'TextField'), isTrue);
        expect(registry.canAcceptChild('Column', 'TextField'), isTrue);
        expect(registry.canAcceptChild('Card', 'TextField'), isTrue);
      });

      test('Text can go in any accepting parent', () {
        expect(registry.canAcceptChild('Container', 'Text'), isTrue);
        expect(registry.canAcceptChild('Row', 'Text'), isTrue);
        expect(registry.canAcceptChild('Column', 'Text'), isTrue);
        expect(registry.canAcceptChild('Padding', 'Text'), isTrue);
      });
    });
  });

  group('Widget Tree Parent-Child Relationship', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    testWidgets(
      'after nested drop, widget node has correct parentId',
      (WidgetTester tester) async {
        // This simulates the state after a successful drop
        // The childrenIds array in parent and parentId in child must match
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
            properties: {'data': 'Nested'},
            parentId: 'container1', // This is what we're verifying
          ),
        };

        // Verify parent-child relationship in data model
        expect(nodes['container1']!.childrenIds, contains('text1'));
        expect(nodes['text1']!.parentId, equals('container1'));

        // Verify rendering
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: 'container1',
                nodes: nodes,
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Child should be visible
        expect(find.text('Nested'), findsOneWidget);
      },
    );

    testWidgets(
      'deep nesting maintains correct parent-child chain',
      (WidgetTester tester) async {
        // Column > Container > Row > Text
        final nodes = {
          'column': const WidgetNode(
            id: 'column',
            type: 'Column',
            properties: {},
            childrenIds: ['container'],
          ),
          'container': const WidgetNode(
            id: 'container',
            type: 'Container',
            properties: {'width': 200.0, 'height': 150.0},
            parentId: 'column',
            childrenIds: ['row'],
          ),
          'row': const WidgetNode(
            id: 'row',
            type: 'Row',
            properties: {},
            parentId: 'container',
            childrenIds: ['text'],
          ),
          'text': const WidgetNode(
            id: 'text',
            type: 'Text',
            properties: {'data': 'Deep'},
            parentId: 'row',
          ),
        };

        // Verify the chain
        expect(nodes['column']!.parentId, isNull); // root
        expect(nodes['container']!.parentId, equals('column'));
        expect(nodes['row']!.parentId, equals('container'));
        expect(nodes['text']!.parentId, equals('row'));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: 'column',
                nodes: nodes,
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // All should render
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Row), findsOneWidget);
        expect(find.text('Deep'), findsOneWidget);
      },
    );
  });

  group('Full End-to-End DesignCanvas Nested Drop', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    testWidgets(
      'DesignCanvas propagates onWidgetDropped to child WidgetRenderer',
      (WidgetTester tester) async {
        String? droppedType;
        String? droppedParentId;

        // DesignCanvas with existing Container
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0, 'color': 0xFF0000FF},
          ),
        };

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: DesignCanvas(
                  registry: registry,
                  nodes: nodes,
                  rootId: 'container1',
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                  onWidgetDropped: (type, parentId) {
                    droppedType = type;
                    droppedParentId = parentId;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the nested DragTarget (NestedDropZone inside WidgetRenderer)
        final dragTargets = tester.widgetList<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        // Find one that accepts drops
        for (final target in dragTargets) {
          final willAccept = target.onWillAcceptWithDetails?.call(
                DragTargetDetails<String>(
                  data: 'TextField',
                  offset: Offset.zero,
                ),
              ) ??
              false;
          if (willAccept) {
            target.onAcceptWithDetails?.call(
              DragTargetDetails<String>(data: 'TextField', offset: Offset.zero),
            );
            break;
          }
        }

        // The callback should have been triggered
        expect(droppedType, equals('TextField'));
        expect(droppedParentId, equals('container1'));
      },
    );

    testWidgets(
      'DesignCanvas root drop has null parentId',
      (WidgetTester tester) async {
        String? droppedType;
        String? droppedParentId = 'not-null';

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: DesignCanvas(
                  registry: registry,
                  nodes: const {},
                  rootId: null, // Empty canvas
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                  onWidgetDropped: (type, parentId) {
                    droppedType = type;
                    droppedParentId = parentId;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the root DragTarget
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'Container', offset: Offset.zero),
        );

        expect(droppedType, equals('Container'));
        expect(
          droppedParentId,
          isNull,
          reason: 'Root drop should have null parentId',
        );
      },
    );
  });

  group('Design-Time Placeholder Visibility', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    testWidgets(
      'empty Container shows placeholder that is visible',
      (WidgetTester tester) async {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {}, // Empty properties - no size, color, or child
          ),
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: WidgetRenderer(
                  nodeId: 'container1',
                  nodes: nodes,
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should show 'Container' placeholder
        expect(find.text('Container'), findsOneWidget);

        // Placeholder should have non-zero size
        final size = tester.getSize(find.text('Container'));
        expect(size.width, greaterThan(0));
        expect(size.height, greaterThan(0));
      },
    );

    testWidgets(
      'Container with child shows child instead of placeholder',
      (WidgetTester tester) async {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {}, // No size/color but has child
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Child Text'},
            parentId: 'container1',
          ),
        };

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: WidgetRenderer(
                  nodeId: 'container1',
                  nodes: nodes,
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should NOT show 'Container' placeholder
        expect(find.text('Container'), findsNothing);

        // Should show child text
        expect(find.text('Child Text'), findsOneWidget);
      },
    );

    testWidgets(
      'empty placeholder still has drop zone',
      (WidgetTester tester) async {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {},
          ),
        };

        String? droppedType;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: WidgetRenderer(
                  nodeId: 'container1',
                  nodes: nodes,
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                  onWidgetDropped: (type, _) {
                    droppedType = type;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify drop zone exists
        expect(find.byType(NestedDropZone), findsOneWidget);

        // Find DragTarget and simulate drop
        final dragTarget = tester.widget<DragTarget<String>>(
          find.byType(DragTarget<String>),
        );

        dragTarget.onAcceptWithDetails?.call(
          DragTargetDetails<String>(data: 'TextField', offset: Offset.zero),
        );

        expect(droppedType, equals('TextField'));
      },
    );
  });
}
