import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Empty/Default state tests for all widget types.
///
/// G3/G4 Gate requirement: Every UI component MUST be tested in its
/// initial/empty state. This catches bugs where widgets are invisible
/// or non-functional when first created.
void main() {
  late WidgetRegistry registry;

  setUp(() {
    registry = DefaultWidgetRegistry();
  });

  group('Empty State Tests (G3/G4 Requirement)', () {
    group('Container', () {
      testWidgets(
        'renders visible placeholder when dropped with no properties',
        (WidgetTester tester) async {
          // Simulate what happens when user drops Container with no config
          final node = WidgetNode(
            id: 'test-container',
            type: 'Container',
            properties: const {}, // Empty - like fresh drop
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WidgetRenderer(
                  nodeId: node.id,
                  nodes: {node.id: node},
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          );

          // Should find a visible widget (the placeholder)
          expect(find.text('Container'), findsOneWidget);

          // Verify non-zero size
          final placeholder = find.text('Container');
          final size = tester.getSize(placeholder);
          expect(size.width, greaterThan(0));
          expect(size.height, greaterThan(0));
        },
      );

      testWidgets(
        'renders with properties when configured',
        (WidgetTester tester) async {
          final node = WidgetNode(
            id: 'test-container',
            type: 'Container',
            properties: const {
              'width': 200.0,
              'height': 150.0,
              'color': 0xFF0000FF, // Blue
            },
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WidgetRenderer(
                  nodeId: node.id,
                  nodes: {node.id: node},
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          );

          // Should find actual Container (not placeholder)
          final containerFinder = find.byType(Container);
          expect(containerFinder, findsWidgets);

          // Should not show placeholder text when configured
          expect(find.text('Container'), findsNothing);
        },
      );
    });

    group('SizedBox', () {
      testWidgets(
        'renders visible placeholder when dropped with no properties',
        (WidgetTester tester) async {
          final node = WidgetNode(
            id: 'test-sizedbox',
            type: 'SizedBox',
            properties: const {},
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WidgetRenderer(
                  nodeId: node.id,
                  nodes: {node.id: node},
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          );

          // Should find placeholder
          expect(find.text('SizedBox'), findsOneWidget);

          // Verify non-zero size
          final size = tester.getSize(find.text('SizedBox'));
          expect(size.width, greaterThan(0));
          expect(size.height, greaterThan(0));
        },
      );

      testWidgets('renders with dimensions when configured', (
        WidgetTester tester,
      ) async {
        final node = WidgetNode(
          id: 'test-sizedbox',
          type: 'SizedBox',
          properties: const {
            'width': 100.0,
            'height': 50.0,
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: node.id,
                nodes: {node.id: node},
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
              ),
            ),
          ),
        );

        // Should render actual SizedBox
        expect(find.byType(SizedBox), findsWidgets);
        // Should not show placeholder
        expect(find.text('SizedBox'), findsNothing);
      });
    });

    group('Row', () {
      testWidgets(
        'renders visible placeholder when dropped with no children',
        (WidgetTester tester) async {
          final node = WidgetNode(
            id: 'test-row',
            type: 'Row',
            properties: const {},
            childrenIds: const [], // No children
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WidgetRenderer(
                  nodeId: node.id,
                  nodes: {node.id: node},
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          );

          // Should find placeholder
          expect(find.text('Row'), findsOneWidget);

          // Verify non-zero size (wider than tall for Row)
          final size = tester.getSize(find.text('Row'));
          expect(size.width, greaterThan(0));
          expect(size.height, greaterThan(0));
        },
      );

      testWidgets('renders children when populated', (
        WidgetTester tester,
      ) async {
        final textNode = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: const {'data': 'Hello'},
          parentId: 'test-row',
        );

        final rowNode = WidgetNode(
          id: 'test-row',
          type: 'Row',
          properties: const {},
          childrenIds: const ['text-1'],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: rowNode.id,
                nodes: {rowNode.id: rowNode, textNode.id: textNode},
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
              ),
            ),
          ),
        );

        // Should render actual Row with Text child
        expect(find.byType(Row), findsOneWidget);
        expect(find.text('Hello'), findsOneWidget);
        // Should not show placeholder
        expect(find.text('Row'), findsNothing);
      });
    });

    group('Column', () {
      testWidgets(
        'renders visible placeholder when dropped with no children',
        (WidgetTester tester) async {
          final node = WidgetNode(
            id: 'test-column',
            type: 'Column',
            properties: const {},
            childrenIds: const [],
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WidgetRenderer(
                  nodeId: node.id,
                  nodes: {node.id: node},
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          );

          // Should find placeholder
          expect(find.text('Column'), findsOneWidget);

          // Verify non-zero size (taller than wide for Column)
          final size = tester.getSize(find.text('Column'));
          expect(size.width, greaterThan(0));
          expect(size.height, greaterThan(0));
        },
      );

      testWidgets('renders children when populated', (
        WidgetTester tester,
      ) async {
        final textNode = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: const {'data': 'World'},
          parentId: 'test-column',
        );

        final columnNode = WidgetNode(
          id: 'test-column',
          type: 'Column',
          properties: const {},
          childrenIds: const ['text-1'],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WidgetRenderer(
                nodeId: columnNode.id,
                nodes: {columnNode.id: columnNode, textNode.id: textNode},
                registry: registry,
                selectedWidgetId: null,
                onWidgetSelected: (_) {},
              ),
            ),
          ),
        );

        // Should render actual Column
        expect(find.byType(Column), findsOneWidget);
        expect(find.text('World'), findsOneWidget);
        // Should not show placeholder
        expect(find.text('Column'), findsNothing);
      });
    });

    group('Text', () {
      testWidgets(
        'renders with default text when dropped with no data property',
        (WidgetTester tester) async {
          final node = WidgetNode(
            id: 'test-text',
            type: 'Text',
            properties: const {}, // No data property
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: WidgetRenderer(
                  nodeId: node.id,
                  nodes: {node.id: node},
                  registry: registry,
                  selectedWidgetId: null,
                  onWidgetSelected: (_) {},
                ),
              ),
            ),
          );

          // Should render with default "Text" content
          expect(find.text('Text'), findsOneWidget);

          // Verify visible
          final size = tester.getSize(find.text('Text'));
          expect(size.width, greaterThan(0));
          expect(size.height, greaterThan(0));
        },
      );
    });
  });

  group('Transition Tests (Empty to Configured)', () {
    testWidgets('Container transitions from placeholder to actual when sized', (
      WidgetTester tester,
    ) async {
      // Start with empty
      var node = WidgetNode(
        id: 'test',
        type: 'Container',
        properties: const {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRenderer(
              nodeId: node.id,
              nodes: {node.id: node},
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
            ),
          ),
        ),
      );

      // Should show placeholder
      expect(find.text('Container'), findsOneWidget);

      // Now update with properties
      node = node.copyWith(properties: {'width': 200.0, 'height': 100.0});

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRenderer(
              nodeId: node.id,
              nodes: {node.id: node},
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
            ),
          ),
        ),
      );

      // Placeholder should be gone
      expect(find.text('Container'), findsNothing);
    });
  });
}
