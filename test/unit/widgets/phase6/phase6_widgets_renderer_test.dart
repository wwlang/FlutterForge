import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/canvas/widget_renderer.dart';
import 'package:flutter_forge/shared/registry/registry.dart';

void main() {
  group('Phase 6 Widget Renderer Tests', () {
    late DefaultWidgetRegistry registry;

    setUp(() {
      registry = DefaultWidgetRegistry();
    });

    Widget buildRenderer(WidgetNode node, Map<String, WidgetNode> nodes) {
      return MaterialApp(
        home: Scaffold(
          body: WidgetRenderer(
            nodeId: node.id,
            nodes: nodes,
            registry: registry,
            selectedWidgetId: null,
            onWidgetSelected: (_) {},
          ),
        ),
      );
    }

    group('TextField Widget', () {
      testWidgets('renders with default properties', (tester) async {
        final node = WidgetNode(
          id: 'textfield-1',
          type: 'TextField',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('renders with label text', (tester) async {
        final node = WidgetNode(
          id: 'textfield-2',
          type: 'TextField',
          properties: const {'labelText': 'Email'},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('renders with hint text', (tester) async {
        final node = WidgetNode(
          id: 'textfield-3',
          type: 'TextField',
          properties: const {'hintText': 'Enter email'},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('Enter email'), findsOneWidget);
      });

      testWidgets('renders with obscure text', (tester) async {
        final node = WidgetNode(
          id: 'textfield-4',
          type: 'TextField',
          properties: const {'obscureText': true},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.obscureText, isTrue);
      });

      testWidgets('renders disabled when enabled is false', (tester) async {
        final node = WidgetNode(
          id: 'textfield-5',
          type: 'TextField',
          properties: const {'enabled': false},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.enabled, isFalse);
      });
    });

    group('Checkbox Widget', () {
      testWidgets('renders unchecked by default', (tester) async {
        final node = WidgetNode(
          id: 'checkbox-1',
          type: 'Checkbox',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Checkbox), findsOneWidget);
        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isFalse);
      });

      testWidgets('renders checked when value is true', (tester) async {
        final node = WidgetNode(
          id: 'checkbox-2',
          type: 'Checkbox',
          properties: const {'value': true},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isTrue);
      });
    });

    group('Switch Widget', () {
      testWidgets('renders off by default', (tester) async {
        final node = WidgetNode(
          id: 'switch-1',
          type: 'Switch',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Switch), findsOneWidget);
        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isFalse);
      });

      testWidgets('renders on when value is true', (tester) async {
        final node = WidgetNode(
          id: 'switch-2',
          type: 'Switch',
          properties: const {'value': true},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isTrue);
      });
    });

    group('Slider Widget', () {
      testWidgets('renders with default value', (tester) async {
        final node = WidgetNode(
          id: 'slider-1',
          type: 'Slider',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Slider), findsOneWidget);
        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.value, 0.5);
      });

      testWidgets('renders with custom min/max', (tester) async {
        final node = WidgetNode(
          id: 'slider-2',
          type: 'Slider',
          properties: const {'min': 0.0, 'max': 100.0, 'value': 50.0},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        final slider = tester.widget<Slider>(find.byType(Slider));
        expect(slider.min, 0.0);
        expect(slider.max, 100.0);
        expect(slider.value, 50.0);
      });
    });

    group('ListView Widget', () {
      testWidgets('renders placeholder when empty', (tester) async {
        final node = WidgetNode(
          id: 'listview-1',
          type: 'ListView',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('ListView'), findsOneWidget);
      });

      testWidgets('renders children when provided', (tester) async {
        final textNode = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: const {'data': 'List Item'},
          childrenIds: const [],
        );
        final listNode = WidgetNode(
          id: 'listview-2',
          type: 'ListView',
          properties: const {'shrinkWrap': true},
          childrenIds: const ['text-1'],
        );
        final nodes = {textNode.id: textNode, listNode.id: listNode};

        await tester.pumpWidget(buildRenderer(listNode, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(ListView), findsOneWidget);
        expect(find.text('List Item'), findsOneWidget);
      });
    });

    group('GridView Widget', () {
      testWidgets('renders placeholder when empty', (tester) async {
        final node = WidgetNode(
          id: 'gridview-1',
          type: 'GridView',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('GridView'), findsOneWidget);
      });
    });

    group('SingleChildScrollView Widget', () {
      testWidgets('renders placeholder when empty', (tester) async {
        final node = WidgetNode(
          id: 'scrollview-1',
          type: 'SingleChildScrollView',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('ScrollView'), findsOneWidget);
      });
    });

    group('Card Widget', () {
      testWidgets('renders with default placeholder', (tester) async {
        final node = WidgetNode(
          id: 'card-1',
          type: 'Card',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Card'), findsOneWidget);
      });

      testWidgets('renders with child', (tester) async {
        final textNode = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: const {'data': 'Card Content'},
          childrenIds: const [],
        );
        final cardNode = WidgetNode(
          id: 'card-2',
          type: 'Card',
          properties: const {},
          childrenIds: const ['text-1'],
        );
        final nodes = {textNode.id: textNode, cardNode.id: cardNode};

        await tester.pumpWidget(buildRenderer(cardNode, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Card), findsOneWidget);
        expect(find.text('Card Content'), findsOneWidget);
      });
    });

    group('ListTile Widget', () {
      testWidgets('renders with title', (tester) async {
        final node = WidgetNode(
          id: 'listtile-1',
          type: 'ListTile',
          properties: const {'title': 'My Title'},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('My Title'), findsOneWidget);
      });

      testWidgets('renders with subtitle', (tester) async {
        final node = WidgetNode(
          id: 'listtile-2',
          type: 'ListTile',
          properties: const {'title': 'Title', 'subtitle': 'Subtitle'},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Subtitle'), findsOneWidget);
      });

      testWidgets('renders with icons', (tester) async {
        final node = WidgetNode(
          id: 'listtile-3',
          type: 'ListTile',
          properties: const {
            'title': 'Settings',
            'leadingIcon': 'Icons.settings',
            'trailingIcon': 'Icons.chevron_right',
          },
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.settings), findsOneWidget);
        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });

    group('AppBar Widget', () {
      testWidgets('renders with title', (tester) async {
        final node = WidgetNode(
          id: 'appbar-1',
          type: 'AppBar',
          properties: const {'title': 'My App'},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('My App'), findsOneWidget);
      });
    });

    group('Scaffold Widget', () {
      testWidgets('renders with placeholder body', (tester) async {
        final node = WidgetNode(
          id: 'scaffold-1',
          type: 'Scaffold',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
        expect(find.text('Scaffold Body'), findsOneWidget);
      });
    });

    group('Wrap Widget', () {
      testWidgets('renders placeholder when empty', (tester) async {
        final node = WidgetNode(
          id: 'wrap-1',
          type: 'Wrap',
          properties: const {},
          childrenIds: const [],
        );
        final nodes = {node.id: node};

        await tester.pumpWidget(buildRenderer(node, nodes));
        await tester.pumpAndSettle();

        expect(find.text('Wrap'), findsOneWidget);
      });

      testWidgets('renders children with spacing', (tester) async {
        final text1 = WidgetNode(
          id: 'text-1',
          type: 'Text',
          properties: const {'data': 'Tag 1'},
          childrenIds: const [],
        );
        final text2 = WidgetNode(
          id: 'text-2',
          type: 'Text',
          properties: const {'data': 'Tag 2'},
          childrenIds: const [],
        );
        final wrapNode = WidgetNode(
          id: 'wrap-2',
          type: 'Wrap',
          properties: const {'spacing': 8.0, 'runSpacing': 4.0},
          childrenIds: const ['text-1', 'text-2'],
        );
        final nodes = {
          text1.id: text1,
          text2.id: text2,
          wrapNode.id: wrapNode,
        };

        await tester.pumpWidget(buildRenderer(wrapNode, nodes));
        await tester.pumpAndSettle();

        expect(find.byType(Wrap), findsOneWidget);
        expect(find.text('Tag 1'), findsOneWidget);
        expect(find.text('Tag 2'), findsOneWidget);
      });
    });
  });
}
