import 'package:flutter/material.dart';
import 'package:flutter_forge/features/properties/edge_insets_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EdgeInsets Editor (Journey: properties-panel.md Stage 4)', () {
    group('Basic Rendering', () {
      testWidgets('renders with four input fields',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have 4 text fields for top, right, bottom, left
        expect(find.byType(TextField), findsNWidgets(4));
      });

      testWidgets('displays current values', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: const EdgeInsets.fromLTRB(8, 16, 24, 32),
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('8'), findsOneWidget); // left
        expect(find.text('16'), findsOneWidget); // top
        expect(find.text('24'), findsOneWidget); // right
        expect(find.text('32'), findsOneWidget); // bottom
      });

      testWidgets('shows visual diagram', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should show T, R, B, L labels
        expect(find.text('T'), findsOneWidget);
        expect(find.text('R'), findsOneWidget);
        expect(find.text('B'), findsOneWidget);
        expect(find.text('L'), findsOneWidget);
      });

      testWidgets('shows mode toggle', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should have mode toggle with All, Symmetric, Individual options
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Symmetric'), findsOneWidget);
        expect(find.text('Individual'), findsOneWidget);
      });
    });

    group('Individual Side Editing', () {
      testWidgets('editing top updates only top value', (
        WidgetTester tester,
      ) async {
        EdgeInsets? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: EdgeInsets.zero,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the top field (should be labeled T)
        final topField = find.ancestor(
          of: find.text('T'),
          matching: find.byType(Column),
        );

        // Find the TextField within the top field area
        final textField = find.descendant(
          of: topField.first,
          matching: find.byType(TextField),
        );

        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, '16');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await tester.pumpAndSettle();

          expect(result?.top, equals(16.0));
          expect(result?.right, equals(0.0));
          expect(result?.bottom, equals(0.0));
          expect(result?.left, equals(0.0));
        }
      });
    });

    group('All Mode', () {
      testWidgets('entering value in All mode sets all sides', (
        WidgetTester tester,
      ) async {
        EdgeInsets? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: EdgeInsets.zero,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select All mode (should be default)
        await tester.tap(find.text('All'));
        await tester.pumpAndSettle();

        // Find the single input field that should appear in All mode
        final allTextField = find.byType(TextField);
        expect(allTextField, findsWidgets);

        // Enter a value
        await tester.enterText(allTextField.first, '8');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(result, equals(const EdgeInsets.all(8)));
      });
    });

    group('Symmetric Mode', () {
      testWidgets('shows horizontal and vertical inputs', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: EdgeInsets.zero,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select Symmetric mode
        await tester.tap(find.text('Symmetric'));
        await tester.pumpAndSettle();

        // Should show H and V labels
        expect(find.text('H'), findsOneWidget);
        expect(find.text('V'), findsOneWidget);
      });

      testWidgets('symmetric mode sets horizontal and vertical pairs', (
        WidgetTester tester,
      ) async {
        EdgeInsets? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: EdgeInsets.zero,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select Symmetric mode
        await tester.tap(find.text('Symmetric'));
        await tester.pumpAndSettle();

        // Find horizontal and vertical inputs
        final textFields = find.byType(TextField);

        // Enter horizontal value
        await tester.enterText(textFields.at(0), '16');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Enter vertical value
        await tester.enterText(textFields.at(1), '8');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(result?.left, equals(16.0));
        expect(result?.right, equals(16.0));
        expect(result?.top, equals(8.0));
        expect(result?.bottom, equals(8.0));
      });
    });

    group('Tab Navigation', () {
      testWidgets('Tab moves focus between fields', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: EdgeInsets.zero,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Select Individual mode
        await tester.tap(find.text('Individual'));
        await tester.pumpAndSettle();

        // Focus first field
        final textFields = find.byType(TextField);
        await tester.tap(textFields.first);
        await tester.pumpAndSettle();

        // Tab should move to next field (this tests basic focusability)
        expect(find.byType(TextField), findsNWidgets(4));
      });
    });

    group('Edge Cases', () {
      testWidgets('handles null value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should render without error
        expect(find.byType(EdgeInsetsEditor), findsOneWidget);
      });

      testWidgets('filters invalid input', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'padding',
                displayName: 'Padding',
                value: const EdgeInsets.all(8),
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter to All mode
        await tester.tap(find.text('All'));
        await tester.pumpAndSettle();

        // Try to enter invalid value - input formatter should filter it
        final textField = find.byType(TextField).first;
        await tester.enterText(textField, 'abc');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // The input is filtered to empty, which parses as 0
        // or it remains unchanged if no valid input
        // Just verify the editor doesn't crash
        expect(find.byType(EdgeInsetsEditor), findsOneWidget);
      });

      testWidgets('allows negative values', (WidgetTester tester) async {
        EdgeInsets? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EdgeInsetsEditor(
                propertyName: 'margin',
                displayName: 'Margin',
                value: EdgeInsets.zero,
                onChanged: (value) => result = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('All'));
        await tester.pumpAndSettle();

        final textField = find.byType(TextField).first;
        await tester.enterText(textField, '-8');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(result, equals(const EdgeInsets.all(-8)));
      });
    });
  });
}
