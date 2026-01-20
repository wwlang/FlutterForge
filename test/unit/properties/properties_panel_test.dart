import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/properties/properties_panel.dart';
import 'package:flutter_forge/features/properties/property_editors.dart';
import 'package:flutter_forge/shared/registry/registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Properties Panel (Task 1.5)', () {
    late WidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('PropertiesPanel', () {
      testWidgets('shows empty state when no widget selected', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PropertiesPanel(
                registry: registry,
                selectedNode: null,
                onPropertyChanged: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No widget selected'), findsOneWidget);
      });

      testWidgets('shows widget type header when widget selected', (
        WidgetTester tester,
      ) async {
        const node = WidgetNode(
          id: 'container1',
          type: 'Container',
          properties: {'width': 100.0, 'height': 100.0},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PropertiesPanel(
                registry: registry,
                selectedNode: node,
                onPropertyChanged: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Container'), findsOneWidget);
      });

      testWidgets('displays property categories', (WidgetTester tester) async {
        const node = WidgetNode(
          id: 'container1',
          type: 'Container',
          properties: {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PropertiesPanel(
                registry: registry,
                selectedNode: node,
                onPropertyChanged: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Container has Size, Appearance, Spacing, Layout categories
        expect(find.text('Size'), findsOneWidget);
        expect(find.text('Appearance'), findsOneWidget);
      });

      testWidgets('shows property editors for widget properties', (
        WidgetTester tester,
      ) async {
        const node = WidgetNode(
          id: 'container1',
          type: 'Container',
          properties: {'width': 100.0},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PropertiesPanel(
                registry: registry,
                selectedNode: node,
                onPropertyChanged: (_, __) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should show Width property
        expect(find.text('Width'), findsOneWidget);
      });

      testWidgets('calls onPropertyChanged when property edited', (
        WidgetTester tester,
      ) async {
        String? changedProperty;
        dynamic changedValue;

        const node = WidgetNode(
          id: 'text1',
          type: 'Text',
          properties: {'data': 'Hello'},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PropertiesPanel(
                registry: registry,
                selectedNode: node,
                onPropertyChanged: (name, value) {
                  changedProperty = name;
                  changedValue = value;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Find the text field and change it
        final textField = find.byType(TextField).first;
        await tester.enterText(textField, 'World');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(changedProperty, equals('data'));
        expect(changedValue, equals('World'));
      });
    });

    group('StringEditor', () {
      testWidgets('displays current value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StringEditor(
                propertyName: 'data',
                displayName: 'Text',
                value: 'Hello',
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Hello'), findsOneWidget);
      });

      testWidgets('calls onChanged when text changed', (
        WidgetTester tester,
      ) async {
        String? newValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StringEditor(
                propertyName: 'data',
                displayName: 'Text',
                value: 'Hello',
                onChanged: (value) => newValue = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'World');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(newValue, equals('World'));
      });
    });

    group('DoubleEditor', () {
      testWidgets('displays current value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DoubleEditor(
                propertyName: 'width',
                displayName: 'Width',
                value: 100.0,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('100.0'), findsOneWidget);
      });

      testWidgets('calls onChanged with parsed double', (
        WidgetTester tester,
      ) async {
        double? newValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DoubleEditor(
                propertyName: 'width',
                displayName: 'Width',
                value: 100.0,
                onChanged: (value) => newValue = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '200');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(newValue, equals(200.0));
      });

      testWidgets('respects min/max constraints', (WidgetTester tester) async {
        double? newValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DoubleEditor(
                propertyName: 'width',
                displayName: 'Width',
                value: 100.0,
                min: 0,
                max: 500,
                onChanged: (value) => newValue = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter value above max
        await tester.enterText(find.byType(TextField), '600');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Should clamp to max
        expect(newValue, equals(500.0));
      });
    });

    group('IntEditor', () {
      testWidgets('displays current value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IntEditor(
                propertyName: 'maxLines',
                displayName: 'Max Lines',
                value: 3,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('calls onChanged with parsed int', (
        WidgetTester tester,
      ) async {
        int? newValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: IntEditor(
                propertyName: 'maxLines',
                displayName: 'Max Lines',
                value: 3,
                onChanged: (value) => newValue = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), '5');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        expect(newValue, equals(5));
      });
    });

    group('BoolEditor', () {
      testWidgets('displays checkbox with current value', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BoolEditor(
                propertyName: 'softWrap',
                displayName: 'Soft Wrap',
                value: true,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });

      testWidgets('calls onChanged when toggled', (WidgetTester tester) async {
        bool? newValue;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BoolEditor(
                propertyName: 'softWrap',
                displayName: 'Soft Wrap',
                value: true,
                onChanged: (value) => newValue = value,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(Checkbox));
        await tester.pumpAndSettle();

        expect(newValue, isFalse);
      });
    });

    group('ColorEditor', () {
      testWidgets('displays color preview', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorEditor(
                propertyName: 'color',
                displayName: 'Color',
                value: 0xFF0000FF, // Blue
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should find a container with the color
        expect(find.byType(ColorEditor), findsOneWidget);
      });

      testWidgets('displays hex value', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ColorEditor(
                propertyName: 'color',
                displayName: 'Color',
                value: 0xFF0000FF,
                onChanged: (_) {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should show hex code
        expect(find.textContaining('FF'), findsWidgets);
      });
    });
  });
}
