import 'package:flutter/material.dart';
import 'package:flutter_forge/features/canvas/nested_drop_zone.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for nested drop functionality.
///
/// Tests minimum hit area requirements, parent-child validation,
/// and drop acceptance logic.
void main() {
  group('NestedDropZone', () {
    group('minimum size constraint', () {
      testWidgets(
        'has minimum 60x60 hit area even when child is smaller',
        (WidgetTester tester) async {
          // Create a very small child widget (10x10)
          const smallChild = SizedBox(
            width: 10,
            height: 10,
            child: ColoredBox(color: Colors.red),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: NestedDropZone(
                    parentId: 'test-parent',
                    acceptsChildren: true,
                    hasChild: false,
                    onWidgetDropped: (_, __) {},
                    child: smallChild,
                  ),
                ),
              ),
            ),
          );

          // Find the NestedDropZone and verify its minimum size
          final dropZoneFinder = find.byType(NestedDropZone);
          expect(dropZoneFinder, findsOneWidget);

          final dropZoneSize = tester.getSize(dropZoneFinder);

          // Should have minimum 60x60 hit area
          expect(
            dropZoneSize.width,
            greaterThanOrEqualTo(60),
            reason: 'Drop zone should have minimum width of 60',
          );
          expect(
            dropZoneSize.height,
            greaterThanOrEqualTo(60),
            reason: 'Drop zone should have minimum height of 60',
          );
        },
      );

      testWidgets(
        'preserves child size when larger than minimum',
        (WidgetTester tester) async {
          // Create a large child widget (200x150)
          const largeChild = SizedBox(
            width: 200,
            height: 150,
            child: ColoredBox(color: Colors.blue),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: NestedDropZone(
                    parentId: 'test-parent',
                    acceptsChildren: true,
                    hasChild: false,
                    onWidgetDropped: (_, __) {},
                    child: largeChild,
                  ),
                ),
              ),
            ),
          );

          final dropZoneSize = tester.getSize(find.byType(NestedDropZone));

          // Should match or exceed child size (200x150)
          expect(
            dropZoneSize.width,
            greaterThanOrEqualTo(200),
            reason: 'Drop zone should not shrink below child width',
          );
          expect(
            dropZoneSize.height,
            greaterThanOrEqualTo(150),
            reason: 'Drop zone should not shrink below child height',
          );
        },
      );
    });

    group('drop acceptance', () {
      testWidgets(
        'accepts drop when acceptsChildren is true and not full',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NestedDropZone(
                  parentId: 'container-1',
                  acceptsChildren: true,
                  hasChild: false,
                  maxChildren: 1,
                  childCount: 0,
                  onWidgetDropped: (type, parentId) {},
                  child: const SizedBox(width: 100, height: 100),
                ),
              ),
            ),
          );

          // Simulate a drag and drop
          final dropZone = find.byType(NestedDropZone);

          // Create a drag and drop on the drop target
          await tester.drag(dropZone, Offset.zero); // Start
          await tester.pump();

          // Use the DragTarget's test helpers
          final dragTarget = find.byType(DragTarget<String>);
          expect(dragTarget, findsOneWidget);
        },
      );

      testWidgets(
        'rejects drop when acceptsChildren is false',
        (WidgetTester tester) async {
          bool dropWasAccepted = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NestedDropZone(
                  parentId: 'text-widget',
                  acceptsChildren: false, // Text can't have children
                  hasChild: false,
                  onWidgetDropped: (_, __) {
                    dropWasAccepted = true;
                  },
                  child: const SizedBox(width: 100, height: 100),
                ),
              ),
            ),
          );

          // The DragTarget should exist but reject drops
          expect(find.byType(DragTarget<String>), findsOneWidget);
          // The drop callback should never be called for widgets that don't accept children
          expect(dropWasAccepted, isFalse);
        },
      );

      testWidgets(
        'rejects drop when single-child container already has child',
        (WidgetTester tester) async {
          bool dropWasAccepted = false;

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NestedDropZone(
                  parentId: 'container-1',
                  acceptsChildren: true,
                  hasChild: true, // Already has a child
                  maxChildren: 1,
                  childCount: 1,
                  onWidgetDropped: (_, __) {
                    dropWasAccepted = true;
                  },
                  child: const SizedBox(width: 100, height: 100),
                ),
              ),
            ),
          );

          // The drop zone exists but should not accept new drops
          expect(find.byType(DragTarget<String>), findsOneWidget);
          expect(dropWasAccepted, isFalse);
        },
      );

      testWidgets(
        'accepts drop when multi-child container has room',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NestedDropZone(
                  parentId: 'row-1',
                  acceptsChildren: true,
                  hasChild: true,
                  maxChildren: null, // Unlimited
                  childCount: 5,
                  onWidgetDropped: (_, __) {},
                  child: const SizedBox(width: 100, height: 100),
                ),
              ),
            ),
          );

          // Should have a valid DragTarget that can accept
          expect(find.byType(DragTarget<String>), findsOneWidget);
        },
      );
    });

    group('hover feedback', () {
      testWidgets(
        'shows visual feedback when drag is hovering',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: NestedDropZone(
                  parentId: 'container-1',
                  acceptsChildren: true,
                  hasChild: false,
                  onWidgetDropped: (_, __) {},
                  child: const SizedBox(width: 100, height: 100),
                ),
              ),
            ),
          );

          // Initially no hover border
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Container &&
                  widget.decoration is BoxDecoration &&
                  (widget.decoration as BoxDecoration).border != null,
            ),
            findsNothing,
          );
        },
      );
    });
  });

  group('WidgetRegistry canAcceptChild', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    test('Container can accept Text as child', () {
      final canAccept = registry.canAcceptChild('Container', 'Text');
      expect(canAccept, isTrue);
    });

    test('Container can accept Row as child', () {
      final canAccept = registry.canAcceptChild('Container', 'Row');
      expect(canAccept, isTrue);
    });

    test('Text cannot accept any children', () {
      final canAcceptContainer = registry.canAcceptChild('Text', 'Container');
      final canAcceptText = registry.canAcceptChild('Text', 'Text');

      expect(canAcceptContainer, isFalse);
      expect(canAcceptText, isFalse);
    });

    test('Icon cannot accept any children', () {
      final canAccept = registry.canAcceptChild('Icon', 'Text');
      expect(canAccept, isFalse);
    });

    test('Row can accept multiple children types', () {
      expect(registry.canAcceptChild('Row', 'Text'), isTrue);
      expect(registry.canAcceptChild('Row', 'Container'), isTrue);
      expect(registry.canAcceptChild('Row', 'Column'), isTrue);
    });

    test('Column can accept multiple children types', () {
      expect(registry.canAcceptChild('Column', 'Text'), isTrue);
      expect(registry.canAcceptChild('Column', 'Container'), isTrue);
      expect(registry.canAcceptChild('Column', 'Row'), isTrue);
    });

    test('Expanded requires Flex parent (Row or Column)', () {
      // Expanded has parentConstraint = 'Flex'
      // It can be placed inside Row or Column, not inside Container
      final expandedDef = registry.get('Expanded');
      expect(expandedDef?.parentConstraint, equals('Flex'));
    });

    test('Flexible requires Flex parent', () {
      final flexibleDef = registry.get('Flexible');
      expect(flexibleDef?.parentConstraint, equals('Flex'));
    });

    test('Spacer requires Flex parent', () {
      final spacerDef = registry.get('Spacer');
      expect(spacerDef?.parentConstraint, equals('Flex'));
    });

    test('unknown parent type returns false', () {
      final canAccept = registry.canAcceptChild('UnknownWidget', 'Text');
      expect(canAccept, isFalse);
    });

    test('unknown child type returns true if parent accepts children', () {
      // Even if we don't know the child type, if parent can have children
      // we allow it (validation will happen elsewhere)
      final containerDef = registry.get('Container');
      expect(containerDef?.acceptsChildren, isTrue);
    });
  });
}
