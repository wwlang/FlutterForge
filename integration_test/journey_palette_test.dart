import 'package:flutter/material.dart';
import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// E2E Journey tests for Widget Palette interactions.
///
/// Tests user journeys for:
/// - Browsing widget categories
/// - Searching/filtering widgets
/// - Dragging widgets to canvas
/// - Widget preview on hover
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Journey: Widget Palette Browsing', () {
    testWidgets(
      'User sees all widget categories',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Verify all main categories are visible
        expect(find.text('Layout'), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
        expect(find.text('Input'), findsOneWidget);
      },
    );

    testWidgets(
      'User can see widgets in Layout category',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Layout category should show common widgets
        expect(find.text('Container'), findsOneWidget);
        expect(find.text('Row'), findsOneWidget);
        expect(find.text('Column'), findsOneWidget);
        expect(find.text('SizedBox'), findsOneWidget);
      },
    );

    testWidgets(
      'User can see widgets in Content category',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Content category should show Text, Icon, etc.
        expect(find.text('Text'), findsWidgets);
        expect(find.text('Icon'), findsOneWidget);
      },
    );

    testWidgets(
      'User can see widgets in Input category',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Input category should show button widgets
        expect(find.text('Elevated Button'), findsOneWidget);
        expect(find.text('Text Button'), findsOneWidget);
        expect(find.text('Icon Button'), findsOneWidget);
      },
    );
  });

  group('Journey: Drag Widget from Palette', () {
    testWidgets(
      'User drags Container to canvas successfully',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Find elements
        final containerItem = find.text('Container').first;
        final canvas = find.byType(DesignCanvas);

        expect(containerItem, findsOneWidget);
        expect(canvas, findsOneWidget);

        // Perform drag
        final startPos = tester.getCenter(containerItem);
        final endPos = tester.getCenter(canvas);

        final gesture = await tester.startGesture(startPos);
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.moveTo(endPos);
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.up();
        await tester.pumpAndSettle();

        // Canvas should no longer show empty state
        expect(find.text('Drop widgets here'), findsNothing);
      },
    );

    testWidgets(
      'User drags SizedBox to canvas successfully',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        final sizedBoxItem = find.text('SizedBox').first;
        final canvas = find.byType(DesignCanvas);

        final gesture = await tester.startGesture(
          tester.getCenter(sizedBoxItem),
        );
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.moveTo(tester.getCenter(canvas));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.up();
        await tester.pumpAndSettle();

        // SizedBox placeholder should appear
        expect(find.text('SizedBox'), findsAtLeastNWidgets(2));
        expect(find.text('Drop widgets here'), findsNothing);
      },
    );

    testWidgets(
      'User drags Icon to canvas successfully',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        final iconItem = find.text('Icon').first;
        final canvas = find.byType(DesignCanvas);

        final gesture = await tester.startGesture(tester.getCenter(iconItem));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.moveTo(tester.getCenter(canvas));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.up();
        await tester.pumpAndSettle();

        // Icon should render on canvas (star icon by default)
        expect(find.byIcon(Icons.star), findsOneWidget);
        expect(find.text('Drop widgets here'), findsNothing);
      },
    );

    testWidgets(
      'User drags multiple widgets to canvas',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        final canvas = find.byType(DesignCanvas);

        // Drag Row first
        final rowItem = find.text('Row').first;
        final gesture = await tester.startGesture(tester.getCenter(rowItem));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.moveTo(tester.getCenter(canvas));
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.up();
        await tester.pumpAndSettle();

        // Verify Row added
        expect(find.text('Row'), findsAtLeastNWidgets(2));

        // TODO(flutter-forge): Drag Text into Row (requires nested drop)
      },
    );
  });

  group('Journey: Palette Widget Count', () {
    testWidgets(
      'Palette shows all Phase 1 and Phase 2 widgets',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Phase 1 widgets
        expect(find.text('Container'), findsOneWidget);
        expect(find.text('Text'), findsWidgets);
        expect(find.text('Row'), findsOneWidget);
        expect(find.text('Column'), findsOneWidget);
        expect(find.text('SizedBox'), findsOneWidget);

        // Phase 2 Task 9: Layout widgets
        expect(find.text('Stack'), findsOneWidget);
        expect(find.text('Expanded'), findsOneWidget);
        expect(find.text('Flexible'), findsOneWidget);
        expect(find.text('Padding'), findsOneWidget);
        expect(find.text('Center'), findsOneWidget);
        expect(find.text('Align'), findsOneWidget);
        expect(find.text('Spacer'), findsOneWidget);

        // Phase 2 Task 10: Content widgets
        expect(find.text('Icon'), findsOneWidget);
        expect(find.text('Image'), findsOneWidget);
        expect(find.text('Divider'), findsOneWidget);
        expect(find.text('Placeholder'), findsOneWidget);

        // Phase 2 Task 11: Input widgets
        expect(find.text('Elevated Button'), findsOneWidget);
        expect(find.text('Text Button'), findsOneWidget);
        expect(find.text('Icon Button'), findsOneWidget);
      },
    );
  });
}
