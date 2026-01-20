import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/generators/dart_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DartGenerator (Task 1.6)', () {
    late DartGenerator generator;

    setUp(() {
      generator = DartGenerator();
    });

    group('Basic widget generation', () {
      test('generates StatelessWidget class structure', () {
        final nodes = {
          'root': const WidgetNode(
            id: 'root',
            type: 'Container',
            properties: {},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'root',
          className: 'MyWidget',
        );

        expect(code, contains('class MyWidget extends StatelessWidget'));
        expect(code, contains('@override'));
        expect(code, contains('Widget build(BuildContext context)'));
        expect(code, contains("const MyWidget({super.key})"));
      });

      test('generates Container widget', () {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 100.0, 'height': 100.0},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
        );

        expect(code, contains('Container('));
        expect(code, contains('width: 100'));
        expect(code, contains('height: 100'));
      });

      test('generates Container with color', () {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'color': 0xFFFF0000},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
        );

        expect(code, contains('Container('));
        expect(code, contains('color: Color(0xFFFF0000)'));
      });

      test('generates Text widget', () {
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Hello World'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
        );

        expect(code, contains("Text('Hello World'"));
      });

      test('generates Text with style', () {
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {
              'data': 'Styled',
              'fontSize': 24.0,
              'color': 0xFF0000FF,
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
        );

        expect(code, contains("Text("));
        expect(code, contains('Styled'));
        expect(code, contains('TextStyle('));
        expect(code, contains('fontSize: 24'));
        expect(code, contains('color: Color(0xFF0000FF)'));
      });

      test('generates SizedBox widget', () {
        final nodes = {
          'sized1': const WidgetNode(
            id: 'sized1',
            type: 'SizedBox',
            properties: {'width': 50.0, 'height': 30.0},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'sized1',
          className: 'MyWidget',
        );

        expect(code, contains('SizedBox('));
        expect(code, contains('width: 50'));
        expect(code, contains('height: 30'));
      });
    });

    group('Layout widgets', () {
      test('generates Row widget', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            childrenIds: ['text1', 'text2'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'First'},
            parentId: 'row1',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Second'},
            parentId: 'row1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        expect(code, contains('Row('));
        expect(code, contains('children: ['));
        expect(code, contains("Text('First'"));
        expect(code, contains("Text('Second'"));
      });

      test('generates Row with mainAxisAlignment', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {'mainAxisAlignment': 'MainAxisAlignment.center'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        expect(code, contains('mainAxisAlignment: MainAxisAlignment.center'));
      });

      test('generates Column widget', () {
        final nodes = {
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {
              'crossAxisAlignment': 'CrossAxisAlignment.start',
            },
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Item'},
            parentId: 'col1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'col1',
          className: 'MyWidget',
        );

        expect(code, contains('Column('));
        expect(code, contains('crossAxisAlignment: CrossAxisAlignment.start'));
        expect(code, contains('children: ['));
      });
    });

    group('Nested widgets', () {
      test('generates Container with child', () {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 200.0, 'height': 200.0},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Nested'},
            parentId: 'container1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
        );

        expect(code, contains('Container('));
        expect(code, contains('child:'));
        expect(code, contains("Text('Nested'"));
      });

      test('generates deeply nested structure', () {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'color': 0xFFEEEEEE},
            childrenIds: ['column1'],
          ),
          'column1': const WidgetNode(
            id: 'column1',
            type: 'Column',
            properties: {},
            parentId: 'container1',
            childrenIds: ['row1', 'text2'],
          ),
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            parentId: 'column1',
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Row Item'},
            parentId: 'row1',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Column Item'},
            parentId: 'column1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
        );

        expect(code, contains('Container('));
        expect(code, contains('Column('));
        expect(code, contains('Row('));
        expect(code, contains("Text('Row Item'"));
        expect(code, contains("Text('Column Item'"));
      });
    });

    group('Code formatting', () {
      test('produces valid formatted Dart code', () {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'width': 100.0, 'height': 100.0},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Test'},
            parentId: 'container1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
        );

        // Check proper indentation and formatting
        expect(code, contains('import'));
        expect(code, isNot(contains(';;'))); // No double semicolons
        expect(code, isNot(contains('(,'))); // No empty params
      });

      test('includes Flutter import', () {
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Hello'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
        );

        expect(code, contains("import 'package:flutter/material.dart'"));
      });
    });

    group('Edge cases', () {
      test('handles empty properties', () {
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
        );

        expect(code, contains('Container()'));
      });

      test('handles special characters in text', () {
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': "Hello 'World' with \"quotes\""},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
        );

        // Should properly escape quotes
        expect(code, contains('Text('));
      });
    });
  });
}
