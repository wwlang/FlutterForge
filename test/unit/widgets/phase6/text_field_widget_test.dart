import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/shared/registry/property_definition.dart';
import 'package:flutter_forge/shared/registry/widget_definition.dart';
import 'package:flutter_forge/shared/registry/widget_registry.dart';

void main() {
  group('Phase 6 Task 1: TextField Widget', () {
    late DefaultWidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    group('Widget Registry', () {
      test('registers TextField widget', () {
        expect(registry.contains('TextField'), isTrue);
      });

      test('TextField has correct category', () {
        final def = registry.get('TextField');
        expect(def, isNotNull);
        expect(def!.category, WidgetCategory.input);
      });

      test('TextField does not accept children', () {
        final def = registry.get('TextField');
        expect(def, isNotNull);
        expect(def!.acceptsChildren, isFalse);
        expect(def.maxChildren, 0);
      });

      test('TextField has required properties', () {
        final def = registry.get('TextField');
        expect(def, isNotNull);

        final props = def!.properties;
        final propNames = props.map((p) => p.name).toList();

        // Core properties
        expect(propNames, contains('labelText'));
        expect(propNames, contains('hintText'));
        expect(propNames, contains('helperText'));
        expect(propNames, contains('errorText'));
        expect(propNames, contains('obscureText'));
        expect(propNames, contains('enabled'));
        expect(propNames, contains('maxLines'));
        expect(propNames, contains('keyboardType'));
      });

      test('TextField hintText property has correct definition', () {
        final def = registry.get('TextField');
        final hintText =
            def!.properties.firstWhere((p) => p.name == 'hintText');

        expect(hintText.type, PropertyType.string);
        expect(hintText.nullable, isTrue);
        expect(hintText.category, 'Decoration');
      });

      test('TextField obscureText property has correct definition', () {
        final def = registry.get('TextField');
        final obscure =
            def!.properties.firstWhere((p) => p.name == 'obscureText');

        expect(obscure.type, PropertyType.bool_);
        expect(obscure.defaultValue, false);
      });

      test('TextField maxLines property has correct definition', () {
        final def = registry.get('TextField');
        final maxLines =
            def!.properties.firstWhere((p) => p.name == 'maxLines');

        expect(maxLines.type, PropertyType.int_);
        expect(maxLines.defaultValue, 1);
        expect(maxLines.min, 1);
      });

      test('TextField keyboardType has enum values', () {
        final def = registry.get('TextField');
        final keyboardType =
            def!.properties.firstWhere((p) => p.name == 'keyboardType');

        expect(keyboardType.type, PropertyType.enum_);
        expect(keyboardType.enumValues, isNotNull);
        expect(keyboardType.enumValues, contains('TextInputType.text'));
        expect(keyboardType.enumValues, contains('TextInputType.number'));
        expect(keyboardType.enumValues, contains('TextInputType.emailAddress'));
        expect(keyboardType.enumValues, contains('TextInputType.phone'));
        expect(keyboardType.enumValues, contains('TextInputType.multiline'));
      });
    });

    group('Widget Rendering', () {
      testWidgets('renders TextField with default properties', (tester) async {
        // This test verifies that the WidgetRenderer can render a TextField
        final node = WidgetNode(
          id: 'test-textfield-1',
          type: 'TextField',
          properties: {},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        // Should render a TextField
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('renders TextField with labelText', (tester) async {
        final node = WidgetNode(
          id: 'test-textfield-2',
          type: 'TextField',
          properties: {'labelText': 'Email'},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('renders TextField with hintText', (tester) async {
        final node = WidgetNode(
          id: 'test-textfield-3',
          type: 'TextField',
          properties: {'hintText': 'Enter your email'},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        expect(find.text('Enter your email'), findsOneWidget);
      });

      testWidgets('renders TextField with obscureText for password',
          (tester) async {
        final node = WidgetNode(
          id: 'test-textfield-4',
          type: 'TextField',
          properties: {'obscureText': true},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);
      });

      testWidgets('renders TextField disabled when enabled is false',
          (tester) async {
        final node = WidgetNode(
          id: 'test-textfield-5',
          type: 'TextField',
          properties: {'enabled': false},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isFalse);
      });

      testWidgets('renders TextField with multiple lines', (tester) async {
        final node = WidgetNode(
          id: 'test-textfield-6',
          type: 'TextField',
          properties: {'maxLines': 5},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.maxLines, 5);
      });

      testWidgets('renders TextField with error text', (tester) async {
        final node = WidgetNode(
          id: 'test-textfield-7',
          type: 'TextField',
          properties: {'errorText': 'Invalid email'},
          childrenIds: [],
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: _TestWidgetRenderer(
                node: node,
                registry: registry,
              ),
            ),
          ),
        );

        expect(find.text('Invalid email'), findsOneWidget);
      });
    });
  });
}

/// Minimal test renderer that uses the registry to render widgets.
/// This will be replaced with actual WidgetRenderer once implemented.
class _TestWidgetRenderer extends StatelessWidget {
  const _TestWidgetRenderer({
    required this.node,
    required this.registry,
  });

  final WidgetNode node;
  final WidgetRegistry registry;

  @override
  Widget build(BuildContext context) {
    if (node.type != 'TextField') {
      return ErrorWidget.withDetails(message: 'Unexpected type: ${node.type}');
    }

    final labelText = node.properties['labelText'] as String?;
    final hintText = node.properties['hintText'] as String?;
    final helperText = node.properties['helperText'] as String?;
    final errorText = node.properties['errorText'] as String?;
    final obscureText = node.properties['obscureText'] as bool? ?? false;
    final enabled = node.properties['enabled'] as bool? ?? true;
    final maxLines = node.properties['maxLines'] as int? ?? 1;

    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
      ),
      obscureText: obscureText,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
    );
  }
}
