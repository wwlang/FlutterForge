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

  group('DartGenerator Phase 2 Widgets (Task 2.12)', () {
    late DartGenerator generator;

    setUp(() {
      generator = DartGenerator();
    });

    group('Phase 2 Task 9 Layout widgets', () {
      test('generates Stack widget', () {
        final nodes = {
          'stack1': const WidgetNode(
            id: 'stack1',
            type: 'Stack',
            properties: {'fit': 'StackFit.expand'},
            childrenIds: ['text1', 'text2'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'First'},
            parentId: 'stack1',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Second'},
            parentId: 'stack1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'stack1',
          className: 'MyWidget',
        );

        expect(code, contains('Stack('));
        expect(code, contains('fit: StackFit.expand'));
        expect(code, contains('children: ['));
      });

      test('generates Stack with clipBehavior', () {
        final nodes = {
          'stack1': const WidgetNode(
            id: 'stack1',
            type: 'Stack',
            properties: {'clipBehavior': 'Clip.hardEdge'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'stack1',
          className: 'MyWidget',
        );

        expect(code, contains('clipBehavior: Clip.hardEdge'));
      });

      test('generates Expanded widget', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            childrenIds: ['expanded1'],
          ),
          'expanded1': const WidgetNode(
            id: 'expanded1',
            type: 'Expanded',
            properties: {'flex': 2},
            parentId: 'row1',
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Expanded'},
            parentId: 'expanded1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        expect(code, contains('Expanded('));
        expect(code, contains('flex: 2'));
        expect(code, contains('child:'));
      });

      test('generates Flexible widget', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            childrenIds: ['flexible1'],
          ),
          'flexible1': const WidgetNode(
            id: 'flexible1',
            type: 'Flexible',
            properties: {'flex': 1, 'fit': 'FlexFit.loose'},
            parentId: 'row1',
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Flexible'},
            parentId: 'flexible1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        expect(code, contains('Flexible('));
        expect(code, contains('fit: FlexFit.loose'));
      });

      test('generates Spacer widget', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            childrenIds: ['text1', 'spacer1', 'text2'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Left'},
            parentId: 'row1',
          ),
          'spacer1': const WidgetNode(
            id: 'spacer1',
            type: 'Spacer',
            properties: {'flex': 2},
            parentId: 'row1',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Right'},
            parentId: 'row1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        expect(code, contains('Spacer('));
        expect(code, contains('flex: 2'));
      });

      test('generates Padding widget', () {
        final nodes = {
          'padding1': const WidgetNode(
            id: 'padding1',
            type: 'Padding',
            properties: {
              'padding': {'top': 8.0, 'right': 8.0, 'bottom': 8.0, 'left': 8.0}
            },
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Padded'},
            parentId: 'padding1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'padding1',
          className: 'MyWidget',
        );

        expect(code, contains('Padding('));
        expect(code, contains('padding:'));
        expect(code, contains('EdgeInsets'));
      });

      test('generates Center widget', () {
        final nodes = {
          'center1': const WidgetNode(
            id: 'center1',
            type: 'Center',
            properties: {'widthFactor': 2.0, 'heightFactor': 1.5},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Centered'},
            parentId: 'center1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'center1',
          className: 'MyWidget',
        );

        expect(code, contains('Center('));
        expect(code, contains('widthFactor: 2'));
        expect(code, contains('heightFactor: 1.5'));
      });

      test('generates Align widget', () {
        final nodes = {
          'align1': const WidgetNode(
            id: 'align1',
            type: 'Align',
            properties: {'alignment': 'Alignment.topLeft'},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Aligned'},
            parentId: 'align1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'align1',
          className: 'MyWidget',
        );

        expect(code, contains('Align('));
        expect(code, contains('alignment: Alignment.topLeft'));
      });
    });

    group('Phase 2 Task 10 Content widgets', () {
      test('generates Icon widget', () {
        final nodes = {
          'icon1': const WidgetNode(
            id: 'icon1',
            type: 'Icon',
            properties: {
              'icon': 'Icons.star',
              'size': 48.0,
              'color': 0xFFFFD700
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'icon1',
          className: 'MyWidget',
        );

        expect(code, contains('Icon('));
        expect(code, contains('Icons.star'));
        expect(code, contains('size: 48'));
        expect(code, contains('color: Color(0xFFFFD700)'));
      });

      test('generates Image placeholder', () {
        final nodes = {
          'image1': const WidgetNode(
            id: 'image1',
            type: 'Image',
            properties: {
              'width': 200.0,
              'height': 150.0,
              'fit': 'BoxFit.cover',
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'image1',
          className: 'MyWidget',
        );

        // Image generates placeholder since we don't have actual image source
        expect(code, contains('width: 200'));
        expect(code, contains('height: 150'));
      });

      test('generates Divider widget', () {
        final nodes = {
          'divider1': const WidgetNode(
            id: 'divider1',
            type: 'Divider',
            properties: {
              'thickness': 2.0,
              'indent': 16.0,
              'endIndent': 16.0,
              'color': 0xFF808080
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'divider1',
          className: 'MyWidget',
        );

        expect(code, contains('Divider('));
        expect(code, contains('thickness: 2'));
        expect(code, contains('indent: 16'));
        expect(code, contains('endIndent: 16'));
      });

      test('generates VerticalDivider widget', () {
        final nodes = {
          'vdivider1': const WidgetNode(
            id: 'vdivider1',
            type: 'VerticalDivider',
            properties: {
              'thickness': 1.0,
              'width': 24.0,
              'indent': 8.0,
              'endIndent': 8.0
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'vdivider1',
          className: 'MyWidget',
        );

        expect(code, contains('VerticalDivider('));
        expect(code, contains('thickness: 1'));
        expect(code, contains('width: 24'));
      });

      test('generates Placeholder widget', () {
        final nodes = {
          'placeholder1': const WidgetNode(
            id: 'placeholder1',
            type: 'Placeholder',
            properties: {
              'fallbackWidth': 200.0,
              'fallbackHeight': 150.0,
              'strokeWidth': 2.0,
              'color': 0xFF2196F3
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'placeholder1',
          className: 'MyWidget',
        );

        expect(code, contains('Placeholder('));
        expect(code, contains('fallbackWidth: 200'));
        expect(code, contains('fallbackHeight: 150'));
        expect(code, contains('strokeWidth: 2'));
      });
    });

    group('Phase 2 Task 11 Input widgets', () {
      test('generates ElevatedButton with child', () {
        final nodes = {
          'button1': const WidgetNode(
            id: 'button1',
            type: 'ElevatedButton',
            properties: {'onPressed': true},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Click Me'},
            parentId: 'button1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'button1',
          className: 'MyWidget',
        );

        expect(code, contains('ElevatedButton('));
        expect(code, contains('onPressed: () {}'));
        expect(code, contains("child: Text('Click Me'"));
      });

      test('generates ElevatedButton disabled', () {
        final nodes = {
          'button1': const WidgetNode(
            id: 'button1',
            type: 'ElevatedButton',
            properties: {'onPressed': false},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Disabled'},
            parentId: 'button1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'button1',
          className: 'MyWidget',
        );

        expect(code, contains('ElevatedButton('));
        expect(code, contains('onPressed: null'));
      });

      test('generates TextButton with child', () {
        final nodes = {
          'button1': const WidgetNode(
            id: 'button1',
            type: 'TextButton',
            properties: {'onPressed': true},
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Text Button'},
            parentId: 'button1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'button1',
          className: 'MyWidget',
        );

        expect(code, contains('TextButton('));
        expect(code, contains('onPressed: () {}'));
      });

      test('generates IconButton widget', () {
        final nodes = {
          'iconButton1': const WidgetNode(
            id: 'iconButton1',
            type: 'IconButton',
            properties: {
              'icon': 'Icons.add',
              'iconSize': 32.0,
              'color': 0xFF2196F3,
              'tooltip': 'Add Item',
              'onPressed': true,
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'iconButton1',
          className: 'MyWidget',
        );

        expect(code, contains('IconButton('));
        expect(code, contains('icon: Icon(Icons.add)'));
        expect(code, contains('iconSize: 32'));
        expect(code, contains("tooltip: 'Add Item'"));
        expect(code, contains('onPressed: () {}'));
      });

      test('generates IconButton disabled', () {
        final nodes = {
          'iconButton1': const WidgetNode(
            id: 'iconButton1',
            type: 'IconButton',
            properties: {
              'icon': 'Icons.delete',
              'onPressed': false,
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'iconButton1',
          className: 'MyWidget',
        );

        expect(code, contains('IconButton('));
        expect(code, contains('onPressed: null'));
      });
    });

    group('Complex nested structures', () {
      test('generates Row with Expanded children', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {},
            childrenIds: ['expanded1', 'expanded2'],
          ),
          'expanded1': const WidgetNode(
            id: 'expanded1',
            type: 'Expanded',
            properties: {'flex': 1},
            parentId: 'row1',
            childrenIds: ['text1'],
          ),
          'expanded2': const WidgetNode(
            id: 'expanded2',
            type: 'Expanded',
            properties: {'flex': 2},
            parentId: 'row1',
            childrenIds: ['text2'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Small'},
            parentId: 'expanded1',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Large'},
            parentId: 'expanded2',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        expect(code, contains('Row('));
        expect(code, contains('Expanded('));
        expect(code, contains('flex: 1'));
        expect(code, contains('flex: 2'));
      });

      test('generates Column with dividers and buttons', () {
        final nodes = {
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {},
            childrenIds: ['button1', 'divider1', 'button2'],
          ),
          'button1': const WidgetNode(
            id: 'button1',
            type: 'ElevatedButton',
            properties: {'onPressed': true},
            parentId: 'col1',
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Button 1'},
            parentId: 'button1',
          ),
          'divider1': const WidgetNode(
            id: 'divider1',
            type: 'Divider',
            properties: {'thickness': 1.0},
            parentId: 'col1',
          ),
          'button2': const WidgetNode(
            id: 'button2',
            type: 'TextButton',
            properties: {'onPressed': true},
            parentId: 'col1',
            childrenIds: ['text2'],
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Button 2'},
            parentId: 'button2',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'col1',
          className: 'MyWidget',
        );

        expect(code, contains('Column('));
        expect(code, contains('ElevatedButton('));
        expect(code, contains('Divider('));
        expect(code, contains('TextButton('));
      });
    });

    group('All 20 widgets coverage', () {
      test('supports all registered widget types', () {
        // Phase 1 widgets
        final phase1Types = ['Container', 'Text', 'Row', 'Column', 'SizedBox'];
        // Phase 2 Task 9 Layout widgets
        final phase2Task9Types = [
          'Stack',
          'Expanded',
          'Flexible',
          'Padding',
          'Center',
          'Align',
          'Spacer'
        ];
        // Phase 2 Task 10 Content widgets
        final phase2Task10Types = [
          'Icon',
          'Image',
          'Divider',
          'VerticalDivider',
          'Placeholder'
        ];
        // Phase 2 Task 11 Input widgets
        final phase2Task11Types = [
          'ElevatedButton',
          'TextButton',
          'IconButton'
        ];

        final allTypes = [
          ...phase1Types,
          ...phase2Task9Types,
          ...phase2Task10Types,
          ...phase2Task11Types
        ];

        // Generator should not throw for any supported type
        for (final type in allTypes) {
          final nodes = {
            'root': WidgetNode(
              id: 'root',
              type: type,
              properties: _getDefaultPropertiesForType(type),
              childrenIds: _requiresChild(type) ? ['child1'] : [],
            ),
          };

          if (_requiresChild(type)) {
            nodes['child1'] = const WidgetNode(
              id: 'child1',
              type: 'Text',
              properties: {'data': 'Child'},
              parentId: 'root',
            );
          }

          expect(
            () => generator.generate(
              nodes: nodes,
              rootId: 'root',
              className: 'TestWidget',
            ),
            returnsNormally,
            reason: 'Generator should support $type',
          );
        }
      });
    });
  });
}

/// Helper to get default properties for a widget type
Map<String, dynamic> _getDefaultPropertiesForType(String type) {
  switch (type) {
    case 'Text':
      return {'data': 'Test'};
    case 'Icon':
      return {'icon': 'Icons.star'};
    case 'IconButton':
      return {'icon': 'Icons.add', 'onPressed': true};
    case 'ElevatedButton':
    case 'TextButton':
      return {'onPressed': true};
    case 'Padding':
      return {
        'padding': {'top': 8.0, 'right': 8.0, 'bottom': 8.0, 'left': 8.0}
      };
    default:
      return {};
  }
}

/// Check if a widget type requires a child
bool _requiresChild(String type) {
  const singleChildTypes = [
    'Container',
    'SizedBox',
    'Expanded',
    'Flexible',
    'Padding',
    'Center',
    'Align',
    'ElevatedButton',
    'TextButton',
  ];
  return singleChildTypes.contains(type);
}
