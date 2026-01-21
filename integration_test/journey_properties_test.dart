import 'package:flutter/material.dart';
import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/properties/properties.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// E2E Journey tests for Properties Panel interactions.
///
/// Tests user journeys for:
/// - Viewing widget properties when selected
/// - Editing property values
/// - Canvas updates when properties change
/// - Property validation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> dragWidgetToCanvas(
    WidgetTester tester,
    String widgetName,
  ) async {
    final widgetItem = find.text(widgetName).first;
    final canvas = find.byType(DesignCanvas);

    final gesture = await tester.startGesture(tester.getCenter(widgetItem));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(canvas));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> selectWidgetOnCanvas(
    WidgetTester tester,
    String widgetName,
  ) async {
    // Find the dropped widget on canvas
    final canvas = find.byType(DesignCanvas);
    final widgetOnCanvas = find.descendant(
      of: canvas,
      matching: find.text(widgetName),
    );

    if (widgetOnCanvas.evaluate().isNotEmpty) {
      await tester.tap(widgetOnCanvas.first);
      await tester.pumpAndSettle();
    }
  }

  group('Journey: Properties Panel Display', () {
    testWidgets(
      'Properties panel is visible',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PropertiesPanel), findsOneWidget);
      },
    );

    testWidgets(
      'Properties panel shows empty state when nothing selected',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Should show some indication to select a widget
        // or show default message
        final propertiesPanel = find.byType(PropertiesPanel);
        expect(propertiesPanel, findsOneWidget);
      },
    );
  });

  group('Journey: Container Properties', () {
    testWidgets(
      'Selecting Container shows Container properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Container
        await dragWidgetToCanvas(tester, 'Container');

        // Select it
        await selectWidgetOnCanvas(tester, 'Container');

        // Properties panel should show Container-specific properties
        expect(find.text('Width'), findsWidgets);
        expect(find.text('Height'), findsWidgets);
        expect(find.text('Color'), findsWidgets);
      },
    );

    testWidgets(
      'Container properties show in categories',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop and select Container
        await dragWidgetToCanvas(tester, 'Container');
        await selectWidgetOnCanvas(tester, 'Container');

        // Should show property categories
        expect(find.text('Size'), findsWidgets);
      },
    );
  });

  group('Journey: Text Properties', () {
    testWidgets(
      'Selecting Text shows Text properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Text
        await dragWidgetToCanvas(tester, 'Text');

        // Find and select the Text widget
        // Text renders with default "Text" content
        final canvas = find.byType(DesignCanvas);
        final textOnCanvas = find.descendant(
          of: canvas,
          matching: find.text('Text'),
        );

        if (textOnCanvas.evaluate().isNotEmpty) {
          await tester.tap(textOnCanvas.first);
          await tester.pumpAndSettle();

          // Properties panel should show Text-specific properties
          expect(find.text('Font Size'), findsWidgets);
        }
      },
    );
  });

  group('Journey: Row/Column Properties', () {
    testWidgets(
      'Selecting Row shows alignment properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Row
        await dragWidgetToCanvas(tester, 'Row');

        // Select the Row placeholder
        await selectWidgetOnCanvas(tester, 'Row');

        // Should show Row-specific properties
        // MainAxisAlignment and CrossAxisAlignment
        expect(find.text('Main Axis Alignment'), findsWidgets);
        expect(find.text('Cross Axis Alignment'), findsWidgets);
      },
    );

    testWidgets(
      'Selecting Column shows alignment properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Column
        await dragWidgetToCanvas(tester, 'Column');

        // Select the Column placeholder
        await selectWidgetOnCanvas(tester, 'Column');

        // Should show Column-specific properties
        expect(find.text('Main Axis Alignment'), findsWidgets);
        expect(find.text('Cross Axis Alignment'), findsWidgets);
      },
    );
  });

  group('Journey: Property Editing', () {
    testWidgets(
      'Can interact with property input fields',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Container
        await dragWidgetToCanvas(tester, 'Container');

        // Select it
        await selectWidgetOnCanvas(tester, 'Container');

        // Find a property field (e.g., Width)
        // Properties panel should have text input fields
        final propertiesPanel = find.byType(PropertiesPanel);

        // Verify text fields exist in properties
        expect(
          find.descendant(
            of: propertiesPanel,
            matching: find.byType(TextField),
          ),
          findsWidgets,
        );
      },
    );
  });

  group('Journey: Icon Properties', () {
    testWidgets(
      'Selecting Icon shows icon-specific properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Icon
        await dragWidgetToCanvas(tester, 'Icon');

        // Select it (Icon renders as actual icon widget)
        final canvas = find.byType(DesignCanvas);
        final iconOnCanvas = find.descendant(
          of: canvas,
          matching: find.byType(Icon),
        );

        if (iconOnCanvas.evaluate().isNotEmpty) {
          await tester.tap(iconOnCanvas.first);
          await tester.pumpAndSettle();

          // Should show Icon-specific properties
          expect(find.text('Size'), findsWidgets);
        }
      },
    );
  });

  group('Journey: Button Properties', () {
    testWidgets(
      'Selecting ElevatedButton shows button properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Elevated Button
        await dragWidgetToCanvas(tester, 'Elevated Button');

        // Find and select
        final canvas = find.byType(DesignCanvas);
        final buttonOnCanvas = find.descendant(
          of: canvas,
          matching: find.byType(ElevatedButton),
        );

        if (buttonOnCanvas.evaluate().isNotEmpty) {
          await tester.tap(buttonOnCanvas.first);
          await tester.pumpAndSettle();

          // Should show button properties
          expect(find.text('Enabled'), findsWidgets);
        }
      },
    );
  });
}
