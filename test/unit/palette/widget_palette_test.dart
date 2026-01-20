import 'package:flutter/material.dart';
import 'package:flutter_forge/features/palette/palette_category.dart';
import 'package:flutter_forge/features/palette/palette_item.dart';
import 'package:flutter_forge/features/palette/widget_palette.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetPalette', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget buildTestWidget({WidgetRegistry? testRegistry}) {
      return ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: WidgetPalette(registry: testRegistry ?? registry),
          ),
        ),
      );
    }

    testWidgets('displays Layout and Content categories (FR1.1)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify categories are displayed
      expect(find.text('Layout'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('displays widget count per category', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Layout has 11 widgets (Container, Row, Column, SizedBox, Stack,
      // Expanded, Flexible, Padding, Center, Align, Spacer)
      final layoutCount = registry.byCategory(WidgetCategory.layout).length;
      expect(find.text('$layoutCount'), findsOneWidget);

      // Content: Text = 1 widget
      final contentCount = registry.byCategory(WidgetCategory.content).length;
      expect(find.text('$contentCount'), findsOneWidget);
    });

    testWidgets('categories are collapsible', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Initially expanded - should see Container
      expect(find.text('Container'), findsOneWidget);

      // Collapse Layout category
      await tester.tap(find.text('Layout'));
      await tester.pumpAndSettle();

      // Container should be hidden
      expect(find.text('Container'), findsNothing);
    });

    testWidgets('collapsed category can be expanded', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Collapse then expand
      await tester.tap(find.text('Layout'));
      await tester.pumpAndSettle();
      expect(find.text('Container'), findsNothing);

      await tester.tap(find.text('Layout'));
      await tester.pumpAndSettle();
      expect(find.text('Container'), findsOneWidget);
    });

    testWidgets('widgets show name and icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Check Container has name displayed
      expect(find.text('Container'), findsOneWidget);

      // Check icon is displayed (crop_square for Container)
      expect(find.byIcon(Icons.crop_square), findsOneWidget);
    });

    testWidgets('displays all Phase 1 widgets', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Layout widgets
      expect(find.text('Container'), findsOneWidget);
      expect(find.text('Row'), findsOneWidget);
      expect(find.text('Column'), findsOneWidget);
      expect(find.text('SizedBox'), findsOneWidget);

      // Content widget (may need to expand Content category)
      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('displays Phase 2 layout widgets', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Phase 2 Task 9 widgets
      expect(find.text('Stack'), findsOneWidget);
      expect(find.text('Expanded'), findsOneWidget);
      expect(find.text('Flexible'), findsOneWidget);
      expect(find.text('Padding'), findsOneWidget);
      expect(find.text('Center'), findsOneWidget);
      expect(find.text('Align'), findsOneWidget);
      expect(find.text('Spacer'), findsOneWidget);
    });
  });

  group('PaletteCategory', () {
    testWidgets('shows category header with name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteCategory(
              name: 'Layout',
              count: 4,
              isExpanded: true,
              onToggle: null,
              children: [Text('Widget 1')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Layout'), findsOneWidget);
    });

    testWidgets('shows widget count badge', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteCategory(
              name: 'Layout',
              count: 4,
              isExpanded: true,
              onToggle: null,
              children: [Text('Widget 1')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('shows expand/collapse icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteCategory(
              name: 'Layout',
              count: 4,
              isExpanded: true,
              onToggle: null,
              children: [Text('Widget 1')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Expanded state shows expand_more icon (pointing down)
      expect(find.byIcon(Icons.expand_more), findsOneWidget);
    });

    testWidgets('collapsed state hides children', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteCategory(
              name: 'Layout',
              count: 4,
              isExpanded: false,
              onToggle: null,
              children: [Text('Widget 1')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Child should be hidden when collapsed
      expect(find.text('Widget 1'), findsNothing);
      // Shows expand_less icon (pointing up) when collapsed
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
    });

    testWidgets('calls onToggle when header tapped', (
      WidgetTester tester,
    ) async {
      var toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaletteCategory(
              name: 'Layout',
              count: 4,
              isExpanded: true,
              onToggle: () => toggleCalled = true,
              children: const [Text('Widget 1')],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Layout'));
      expect(toggleCalled, isTrue);
    });
  });

  group('PaletteItem', () {
    testWidgets('displays widget name', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteItem(
              widgetType: 'Container',
              displayName: 'Container',
              iconName: 'crop_square',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Container'), findsOneWidget);
    });

    testWidgets('displays widget icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteItem(
              widgetType: 'Container',
              displayName: 'Container',
              iconName: 'crop_square',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.crop_square), findsOneWidget);
    });

    testWidgets('uses default icon when iconName is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteItem(
              widgetType: 'CustomWidget',
              displayName: 'Custom',
              iconName: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should use default widget icon
      expect(find.byIcon(Icons.widgets), findsOneWidget);
    });

    testWidgets('is draggable', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaletteItem(
              widgetType: 'Container',
              displayName: 'Container',
              iconName: 'crop_square',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the Draggable widget
      expect(find.byType(Draggable<String>), findsOneWidget);
    });
  });
}
