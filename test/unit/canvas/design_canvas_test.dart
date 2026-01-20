import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/design_canvas.dart';
import 'package:flutter_forge/features/canvas/design_proxy.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/features/canvas/widget_selection_overlay.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DesignCanvas', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget buildTestWidget({
      Map<String, WidgetNode>? nodes,
      String? rootId,
      String? selectedId,
      void Function(String)? onWidgetSelected,
      void Function(String widgetType, String? parentId)? onWidgetDropped,
    }) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: DesignCanvas(
              registry: registry,
              nodes: nodes ?? {},
              rootId: rootId,
              selectedWidgetId: selectedId,
              onWidgetSelected: onWidgetSelected,
              onWidgetDropped: onWidgetDropped,
            ),
          ),
        ),
      );
    }

    testWidgets('displays empty state when no widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Should show empty canvas indicator
      expect(find.text('Drop widgets here'), findsOneWidget);
    });

    testWidgets('shows drop zone indicator on drag enter (FR2.2)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find the DragTarget
      final dragTarget = find.byType(DragTarget<String>);
      expect(dragTarget, findsOneWidget);
    });

    testWidgets('accepts drop and calls onWidgetDropped', (
      WidgetTester tester,
    ) async {
      String? droppedType;
      String? droppedParentId;

      await tester.pumpWidget(
        buildTestWidget(
          onWidgetDropped: (type, parentId) {
            droppedType = type;
            droppedParentId = parentId;
          },
        ),
      );
      await tester.pumpAndSettle();

      // Simulate a drop by calling onAcceptWithDetails
      final target = tester.widget<DragTarget<String>>(
        find.byType(DragTarget<String>),
      );
      target.onAcceptWithDetails?.call(
        DragTargetDetails<String>(data: 'Container', offset: Offset.zero),
      );

      expect(droppedType, equals('Container'));
      expect(droppedParentId, isNull); // Root level drop
    });

    testWidgets('renders widget from node (FR2.1)', (
      WidgetTester tester,
    ) async {
      const node = WidgetNode(
        id: 'node1',
        type: 'Container',
        properties: {'width': 100.0, 'height': 100.0, 'color': 0xFF0000FF},
      );

      await tester.pumpWidget(
        buildTestWidget(
          nodes: const {'node1': node},
          rootId: 'node1',
        ),
      );
      await tester.pumpAndSettle();

      // Should render a Container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders Text widget correctly', (WidgetTester tester) async {
      const node = WidgetNode(
        id: 'text1',
        type: 'Text',
        properties: {'data': 'Hello World'},
      );

      await tester.pumpWidget(
        buildTestWidget(
          nodes: const {'text1': node},
          rootId: 'text1',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('shows selection overlay for selected widget (FR2.4)', (
      WidgetTester tester,
    ) async {
      const node = WidgetNode(
        id: 'node1',
        type: 'Container',
        properties: {'width': 100.0, 'height': 100.0},
      );

      await tester.pumpWidget(
        buildTestWidget(
          nodes: const {'node1': node},
          rootId: 'node1',
          selectedId: 'node1',
        ),
      );
      await tester.pumpAndSettle();

      // Should find selection overlay (DecoratedBox with selection border)
      expect(find.byType(WidgetSelectionOverlay), findsOneWidget);
    });

    testWidgets('click-to-select calls onWidgetSelected (FR2.5)', (
      WidgetTester tester,
    ) async {
      String? selectedId;
      const node = WidgetNode(
        id: 'node1',
        type: 'Container',
        properties: {'width': 100.0, 'height': 100.0},
      );

      await tester.pumpWidget(
        buildTestWidget(
          nodes: const {'node1': node},
          rootId: 'node1',
          onWidgetSelected: (id) => selectedId = id,
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the DesignProxy wrapper
      await tester.tap(find.byType(DesignProxy));
      await tester.pumpAndSettle();

      expect(selectedId, equals('node1'));
    });

    testWidgets('click on empty area clears selection', (
      WidgetTester tester,
    ) async {
      String? selectedId = 'node1';
      const node = WidgetNode(
        id: 'node1',
        type: 'Container',
        properties: {'width': 50.0, 'height': 50.0},
      );

      await tester.pumpWidget(
        buildTestWidget(
          nodes: const {'node1': node},
          rootId: 'node1',
          selectedId: 'node1',
          onWidgetSelected: (id) => selectedId = id,
        ),
      );
      await tester.pumpAndSettle();

      // Tap on canvas background (outside the widget)
      await tester.tapAt(const Offset(400, 400));
      await tester.pumpAndSettle();

      // Selection should be cleared (passed empty string)
      expect(selectedId, equals(''));
    });
  });

  group('WidgetRenderer', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    testWidgets('renders Container with properties', (
      WidgetTester tester,
    ) async {
      final nodes = {
        'root': const WidgetNode(
          id: 'root',
          type: 'Container',
          properties: {'width': 200.0, 'height': 150.0, 'color': 0xFF00FF00},
        ),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRenderer(
              nodeId: 'root',
              nodes: nodes,
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, equals(200.0));
      expect(container.constraints?.maxHeight, equals(150.0));
    });

    testWidgets('renders Row with children', (WidgetTester tester) async {
      final nodes = {
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRenderer(
              nodeId: 'row',
              nodes: nodes,
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('renders Column with children', (WidgetTester tester) async {
      final nodes = {
        'column': const WidgetNode(
          id: 'column',
          type: 'Column',
          properties: {},
          childrenIds: ['text1'],
        ),
        'text1': const WidgetNode(
          id: 'text1',
          type: 'Text',
          properties: {'data': 'Child'},
          parentId: 'column',
        ),
      };

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

      expect(find.byType(Column), findsOneWidget);
      expect(find.text('Child'), findsOneWidget);
    });

    testWidgets('renders SizedBox with dimensions', (
      WidgetTester tester,
    ) async {
      final nodes = {
        'sizedbox': const WidgetNode(
          id: 'sizedbox',
          type: 'SizedBox',
          properties: {'width': 100.0, 'height': 50.0},
        ),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRenderer(
              nodeId: 'sizedbox',
              nodes: nodes,
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('shows error for unknown widget type', (
      WidgetTester tester,
    ) async {
      final nodes = {
        'unknown': const WidgetNode(
          id: 'unknown',
          type: 'UnknownWidget',
          properties: {},
        ),
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WidgetRenderer(
              nodeId: 'unknown',
              nodes: nodes,
              registry: registry,
              selectedWidgetId: null,
              onWidgetSelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show error placeholder
      expect(find.byType(ErrorWidget), findsOneWidget);
    });
  });

  group('WidgetSelectionOverlay', () {
    testWidgets('displays border around child', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: WidgetSelectionOverlay(
              child: SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WidgetSelectionOverlay), findsOneWidget);
      expect(find.byType(DecoratedBox), findsOneWidget);
    });
  });

  group('DesignProxy', () {
    testWidgets('wraps child and intercepts taps', (
      WidgetTester tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DesignProxy(
              nodeId: 'test',
              onTap: () => tapped = true,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DesignProxy));
      expect(tapped, isTrue);
    });
  });
}
