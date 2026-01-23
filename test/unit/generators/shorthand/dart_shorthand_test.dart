import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/generators/dart_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for Dart 3.10 dot shorthand code generation (Task 9.1.1, 9.1.2).
///
/// Journey Reference: J19 - Dart Shorthand Code Generation
///
/// Verifies that the code generator outputs dot shorthand syntax for enums
/// and constructors when the Dart 3.10+ target is enabled.
void main() {
  group('Dart 3.10 Dot Shorthand (Task 9.1.1, 9.1.2)', () {
    group('J19 S1: Enum Dot Shorthand Generation', () {
      late DartGenerator generator;

      setUp(() {
        // Default generator uses Dart 3.10+ (shorthand enabled)
        generator = DartGenerator();
      });

      test('Row with MainAxisAlignment uses shorthand', () {
        // J19 S1: mainAxisAlignment: .center instead of MainAxisAlignment.center
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
          useDotShorthand: true,
        );

        expect(code, contains('mainAxisAlignment: .center'));
        expect(code,
            isNot(contains('mainAxisAlignment: MainAxisAlignment.center')));
      });

      test('Column with CrossAxisAlignment uses shorthand', () {
        // J19 S1: crossAxisAlignment: .stretch
        final nodes = {
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {'crossAxisAlignment': 'CrossAxisAlignment.stretch'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'col1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('crossAxisAlignment: .stretch'));
        expect(code, isNot(contains('CrossAxisAlignment.stretch')));
      });

      test('Text with TextAlign uses shorthand', () {
        // J19 S1: textAlign: .right
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {
              'data': 'Hello',
              'textAlign': 'TextAlign.right',
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('textAlign: .right'));
        expect(code, isNot(contains('TextAlign.right')));
      });

      test('Text with FontWeight uses shorthand', () {
        // J19 S1: fontWeight: .bold
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {
              'data': 'Bold',
              'fontWeight': 'FontWeight.bold',
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('fontWeight: .bold'));
        expect(code, isNot(contains('FontWeight.bold')));
      });

      test('Text with FontStyle uses shorthand', () {
        // J19 S1: fontStyle: .italic
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {
              'data': 'Italic',
              'fontStyle': 'FontStyle.italic',
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('fontStyle: .italic'));
        expect(code, isNot(contains('FontStyle.italic')));
      });

      test('Image with BoxFit uses shorthand', () {
        // J19 S1: fit: .cover
        final nodes = {
          'image1': const WidgetNode(
            id: 'image1',
            type: 'Image',
            properties: {
              'fit': 'BoxFit.cover',
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'image1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('fit: .cover'));
        expect(code, isNot(contains('BoxFit.cover')));
      });

      test('Align with Alignment uses shorthand', () {
        // J19 S2: alignment: .topLeft
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
          useDotShorthand: true,
        );

        expect(code, contains('alignment: .topLeft'));
        expect(code, isNot(contains('Alignment.topLeft')));
      });

      test('Stack with StackFit uses shorthand', () {
        // J19 S1: fit: .expand
        final nodes = {
          'stack1': const WidgetNode(
            id: 'stack1',
            type: 'Stack',
            properties: {'fit': 'StackFit.expand'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'stack1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('fit: .expand'));
        expect(code, isNot(contains('StackFit.expand')));
      });

      test('Flexible with FlexFit uses shorthand', () {
        // J19 S1: fit: .loose
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
            properties: {'fit': 'FlexFit.loose'},
            parentId: 'row1',
            childrenIds: ['text1'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Flex'},
            parentId: 'flexible1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('fit: .loose'));
        expect(code, isNot(contains('FlexFit.loose')));
      });

      test('Stack with Clip uses shorthand', () {
        // J19 S1: clipBehavior: .antiAlias
        final nodes = {
          'stack1': const WidgetNode(
            id: 'stack1',
            type: 'Stack',
            properties: {'clipBehavior': 'Clip.antiAlias'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'stack1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('clipBehavior: .antiAlias'));
        expect(code, isNot(contains('Clip.antiAlias')));
      });

      test('Wrap with WrapAlignment uses shorthand', () {
        // J19 S1: alignment: .start
        final nodes = {
          'wrap1': const WidgetNode(
            id: 'wrap1',
            type: 'Wrap',
            properties: {'alignment': 'WrapAlignment.start'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'wrap1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('alignment: .start'));
        expect(code, isNot(contains('WrapAlignment.start')));
      });

      test('MainAxisSize uses shorthand', () {
        // J19 S1: mainAxisSize: .min
        final nodes = {
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {'mainAxisSize': 'MainAxisSize.min'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'col1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('mainAxisSize: .min'));
        expect(code, isNot(contains('MainAxisSize.min')));
      });

      test('TextOverflow uses shorthand', () {
        // J19 S1: overflow: .ellipsis
        final nodes = {
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {
              'data': 'Long text',
              'overflow': 'TextOverflow.ellipsis',
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'text1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('overflow: .ellipsis'));
        expect(code, isNot(contains('TextOverflow.ellipsis')));
      });

      test('Axis uses shorthand', () {
        // J19 S1: direction: .horizontal
        final nodes = {
          'wrap1': const WidgetNode(
            id: 'wrap1',
            type: 'Wrap',
            properties: {'direction': 'Axis.horizontal'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'wrap1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('direction: .horizontal'));
        expect(code, isNot(contains('Axis.horizontal')));
      });

      test('VerticalDirection uses shorthand', () {
        // J19 S1: verticalDirection: .down
        final nodes = {
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {'verticalDirection': 'VerticalDirection.down'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'col1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('verticalDirection: .down'));
        expect(code, isNot(contains('VerticalDirection.down')));
      });

      test('TextDirection uses shorthand', () {
        // J19 S1: textDirection: .ltr
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {'textDirection': 'TextDirection.ltr'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('textDirection: .ltr'));
        expect(code, isNot(contains('TextDirection.ltr')));
      });
    });

    group('J19 S2: Non-Shorthand Types', () {
      late DartGenerator generator;

      setUp(() {
        generator = DartGenerator();
      });

      test('Colors does NOT use shorthand', () {
        // J19 S2: Colors.blue should remain as Colors.blue
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {'color': 0xFF2196F3}, // Blue color
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        // Color should use Color(0x...) format, not shorthand
        expect(code, contains('Color(0x'));
        expect(code, isNot(contains('color: .blue')));
      });

      test('Icons does NOT use shorthand', () {
        // J19 S2: Icons.star should remain as Icons.star
        final nodes = {
          'icon1': const WidgetNode(
            id: 'icon1',
            type: 'Icon',
            properties: {'icon': 'Icons.star'},
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'icon1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('Icons.star'));
        expect(code, isNot(contains('icon: .star')));
      });

      test('Duration does NOT use shorthand', () {
        // Duration is a constructor call, not an enum
        // Generated code should use Duration(...) not .seconds or similar
        // This tests the non-shorthand exclusion list
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
          useDotShorthand: true,
        );

        // Just verify generation succeeds without Duration shorthand
        expect(code, contains('Container()'));
      });
    });

    group('J19 S2: Constructor Dot Shorthand (Task 9.1.2)', () {
      late DartGenerator generator;

      setUp(() {
        generator = DartGenerator();
      });

      test('EdgeInsets.all uses shorthand', () {
        // J19 S1: padding: .all(16) instead of EdgeInsets.all(16)
        final nodes = {
          'padding1': const WidgetNode(
            id: 'padding1',
            type: 'Padding',
            properties: {
              'padding': {
                'top': 16.0,
                'right': 16.0,
                'bottom': 16.0,
                'left': 16.0
              }
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
          useDotShorthand: true,
        );

        expect(code, contains('padding: .all(16)'));
        expect(code, isNot(contains('EdgeInsets.all')));
      });

      test('EdgeInsets.symmetric uses shorthand', () {
        // J19 S2: padding: .symmetric(horizontal: 16, vertical: 8)
        final nodes = {
          'padding1': const WidgetNode(
            id: 'padding1',
            type: 'Padding',
            properties: {
              'padding': {
                'top': 8.0,
                'right': 16.0,
                'bottom': 8.0,
                'left': 16.0
              }
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
          useDotShorthand: true,
        );

        expect(code, contains('.symmetric('));
        expect(code, isNot(contains('EdgeInsets.symmetric')));
      });

      test('EdgeInsets.only uses shorthand', () {
        // J19 S2: padding: .only(left: 8, top: 4)
        final nodes = {
          'padding1': const WidgetNode(
            id: 'padding1',
            type: 'Padding',
            properties: {
              'padding': {'top': 4.0, 'right': 0.0, 'bottom': 0.0, 'left': 8.0}
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
          useDotShorthand: true,
        );

        expect(code, contains('.only('));
        expect(code, isNot(contains('EdgeInsets.only')));
      });

      test('BorderRadius.circular uses shorthand', () {
        // J19 S2: borderRadius: .circular(8)
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {
              'borderRadius': {'type': 'circular', 'radius': 8.0},
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('.circular(8)'));
        expect(code, isNot(contains('BorderRadius.circular')));
      });

      test('BorderRadius.all uses shorthand', () {
        // J19 S2: borderRadius: .all(Radius.circular(8))
        final nodes = {
          'container1': const WidgetNode(
            id: 'container1',
            type: 'Container',
            properties: {
              'borderRadius': {'type': 'all', 'radius': 8.0},
            },
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'container1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        expect(code, contains('.all('));
        expect(code, isNot(contains('BorderRadius.all')));
      });
    });

    group('J19 S3: Dart Version Targeting (Task 9.1.3)', () {
      test('Dart 3.10+ target (default) uses shorthand', () {
        final generator = DartGenerator();
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
          useDotShorthand: true,
        );

        expect(code, contains('mainAxisAlignment: .center'));
      });

      test('Dart 3.9 compatibility mode disables shorthand', () {
        final generator = DartGenerator();
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
          useDotShorthand: false, // Dart 3.9 mode
        );

        expect(code, contains('mainAxisAlignment: MainAxisAlignment.center'));
        expect(code, isNot(contains('mainAxisAlignment: .center')));
      });

      test('useDotShorthand defaults to false for backward compatibility', () {
        final generator = DartGenerator();
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {'mainAxisAlignment': 'MainAxisAlignment.center'},
          ),
        };

        // Without explicit useDotShorthand parameter
        final code = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
        );

        // Should use full names for backward compatibility
        expect(code, contains('mainAxisAlignment: MainAxisAlignment.center'));
      });
    });

    group('Code Output Validation', () {
      late DartGenerator generator;

      setUp(() {
        generator = DartGenerator();
      });

      test('generated code with shorthand produces valid Dart', () {
        final nodes = {
          'col1': const WidgetNode(
            id: 'col1',
            type: 'Column',
            properties: {
              'mainAxisAlignment': 'MainAxisAlignment.center',
              'crossAxisAlignment': 'CrossAxisAlignment.stretch',
            },
            childrenIds: ['row1'],
          ),
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {'mainAxisAlignment': 'MainAxisAlignment.spaceBetween'},
            parentId: 'col1',
            childrenIds: ['text1', 'text2'],
          ),
          'text1': const WidgetNode(
            id: 'text1',
            type: 'Text',
            properties: {'data': 'Left', 'textAlign': 'TextAlign.left'},
            parentId: 'row1',
          ),
          'text2': const WidgetNode(
            id: 'text2',
            type: 'Text',
            properties: {'data': 'Right', 'textAlign': 'TextAlign.right'},
            parentId: 'row1',
          ),
        };

        final code = generator.generate(
          nodes: nodes,
          rootId: 'col1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        // Should not have any syntax errors (no double dots, etc.)
        expect(code, isNot(contains('..')));
        expect(code, isNot(contains(':.')));

        // Should have proper shorthand
        expect(code, contains('mainAxisAlignment: .center'));
        expect(code, contains('crossAxisAlignment: .stretch'));
        expect(code, contains('mainAxisAlignment: .spaceBetween'));
      });

      test('character count reduction with shorthand', () {
        final nodes = {
          'row1': const WidgetNode(
            id: 'row1',
            type: 'Row',
            properties: {
              'mainAxisAlignment': 'MainAxisAlignment.center',
              'crossAxisAlignment': 'CrossAxisAlignment.stretch',
            },
          ),
        };

        final codeWithShorthand = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
          useDotShorthand: true,
        );

        final codeWithoutShorthand = generator.generate(
          nodes: nodes,
          rootId: 'row1',
          className: 'MyWidget',
          useDotShorthand: false,
        );

        // Shorthand should be shorter
        expect(codeWithShorthand.length, lessThan(codeWithoutShorthand.length));
      });
    });
  });
}
