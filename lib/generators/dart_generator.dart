import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'package:flutter_forge/core/models/widget_node.dart';

/// Generates formatted Dart code from a WidgetNode tree.
///
/// Converts the visual widget tree into a StatelessWidget class
/// with proper Flutter code structure.
///
/// Supports all Phase 1 and Phase 2 widgets:
/// - Phase 1: Container, Text, Row, Column, SizedBox
/// - Phase 2 Task 9: Stack, Expanded, Flexible, Padding, Center, Align, Spacer
/// - Phase 2 Task 10: Icon, Image, Divider, VerticalDivider, Placeholder
/// - Phase 2 Task 11: ElevatedButton, TextButton, IconButton
class DartGenerator {
  /// Creates a DartGenerator.
  DartGenerator({DartFormatter? formatter})
      : _formatter = formatter ??
            DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);

  final DartFormatter _formatter;
  final _emitter = DartEmitter(useNullSafetySyntax: true);

  /// Generates Dart code for the widget tree.
  ///
  /// Parameters:
  /// - [nodes]: Map of all widget nodes
  /// - [rootId]: ID of the root widget
  /// - [className]: Name for the generated widget class
  ///
  /// Returns formatted Dart code as a string.
  String generate({
    required Map<String, WidgetNode> nodes,
    required String rootId,
    required String className,
  }) {
    final rootNode = nodes[rootId];
    if (rootNode == null) {
      throw ArgumentError('Root node not found: $rootId');
    }

    // Build the class
    final widgetClass = _buildWidgetClass(
      className: className,
      nodes: nodes,
      rootNode: rootNode,
    );

    // Build the library
    final library = Library(
      (b) => b
        ..directives.add(
          Directive.import('package:flutter/material.dart'),
        )
        ..body.add(widgetClass),
    );

    // Generate and format code
    final code = library.accept(_emitter).toString();
    return _formatter.format(code);
  }

  Class _buildWidgetClass({
    required String className,
    required Map<String, WidgetNode> nodes,
    required WidgetNode rootNode,
  }) {
    return Class(
      (b) => b
        ..name = className
        ..extend = refer('StatelessWidget')
        ..constructors.add(
          Constructor(
            (c) => c
              ..constant = true
              ..optionalParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'key'
                    ..named = true
                    ..toSuper = true,
                ),
              ),
          ),
        )
        ..methods.add(
          Method(
            (m) => m
              ..annotations.add(refer('override'))
              ..returns = refer('Widget')
              ..name = 'build'
              ..requiredParameters.add(
                Parameter(
                  (p) => p
                    ..name = 'context'
                    ..type = refer('BuildContext'),
                ),
              )
              ..body = Block.of([
                const Code('return '),
                _buildWidgetExpression(rootNode, nodes).code,
                const Code(';'),
              ]),
          ),
        ),
    );
  }

  Expression _buildWidgetExpression(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
  ) {
    switch (node.type) {
      // Phase 1 widgets
      case 'Container':
        return _buildContainer(node, nodes);
      case 'Text':
        return _buildText(node);
      case 'Row':
        return _buildRow(node, nodes);
      case 'Column':
        return _buildColumn(node, nodes);
      case 'SizedBox':
        return _buildSizedBox(node, nodes);

      // Phase 2 Task 9: Layout widgets
      case 'Stack':
        return _buildStack(node, nodes);
      case 'Expanded':
        return _buildExpanded(node, nodes);
      case 'Flexible':
        return _buildFlexible(node, nodes);
      case 'Padding':
        return _buildPadding(node, nodes);
      case 'Center':
        return _buildCenter(node, nodes);
      case 'Align':
        return _buildAlign(node, nodes);
      case 'Spacer':
        return _buildSpacer(node);

      // Phase 2 Task 10: Content widgets
      case 'Icon':
        return _buildIcon(node);
      case 'Image':
        return _buildImage(node);
      case 'Divider':
        return _buildDivider(node);
      case 'VerticalDivider':
        return _buildVerticalDivider(node);
      case 'Placeholder':
        return _buildPlaceholder(node);

      // Phase 2 Task 11: Input widgets
      case 'ElevatedButton':
        return _buildElevatedButton(node, nodes);
      case 'TextButton':
        return _buildTextButton(node, nodes);
      case 'IconButton':
        return _buildIconButton(node);

      default:
        throw ArgumentError('Unknown widget type: ${node.type}');
    }
  }

  // Phase 1 widgets

  Expression _buildContainer(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Width
    if (node.properties['width'] != null) {
      args['width'] = literalNum(node.properties['width'] as num);
    }

    // Height
    if (node.properties['height'] != null) {
      args['height'] = literalNum(node.properties['height'] as num);
    }

    // Color
    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      args['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('Container').call([], args);
  }

  Expression _buildText(WidgetNode node) {
    final data = node.properties['data'] as String? ?? '';
    final positionalArgs = [literalString(data)];
    final namedArgs = <String, Expression>{};

    // Build TextStyle if any style properties exist
    final styleArgs = <String, Expression>{};

    if (node.properties['fontSize'] != null) {
      styleArgs['fontSize'] = literalNum(node.properties['fontSize'] as num);
    }

    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      styleArgs['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    if (styleArgs.isNotEmpty) {
      namedArgs['style'] = refer('TextStyle').call([], styleArgs);
    }

    return refer('Text').call(positionalArgs, namedArgs);
  }

  Expression _buildRow(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // MainAxisAlignment
    if (node.properties['mainAxisAlignment'] != null) {
      final alignment = node.properties['mainAxisAlignment'] as String;
      args['mainAxisAlignment'] = refer(alignment);
    }

    // CrossAxisAlignment
    if (node.properties['crossAxisAlignment'] != null) {
      final alignment = node.properties['crossAxisAlignment'] as String;
      args['crossAxisAlignment'] = refer(alignment);
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes);
        }).toList(),
      );
    }

    return refer('Row').call([], args);
  }

  Expression _buildColumn(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // MainAxisAlignment
    if (node.properties['mainAxisAlignment'] != null) {
      final alignment = node.properties['mainAxisAlignment'] as String;
      args['mainAxisAlignment'] = refer(alignment);
    }

    // CrossAxisAlignment
    if (node.properties['crossAxisAlignment'] != null) {
      final alignment = node.properties['crossAxisAlignment'] as String;
      args['crossAxisAlignment'] = refer(alignment);
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes);
        }).toList(),
      );
    }

    return refer('Column').call([], args);
  }

  Expression _buildSizedBox(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Width
    if (node.properties['width'] != null) {
      args['width'] = literalNum(node.properties['width'] as num);
    }

    // Height
    if (node.properties['height'] != null) {
      args['height'] = literalNum(node.properties['height'] as num);
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('SizedBox').call([], args);
  }

  // Phase 2 Task 9: Layout widgets

  Expression _buildStack(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Alignment
    if (node.properties['alignment'] != null) {
      args['alignment'] = refer(node.properties['alignment'] as String);
    }

    // Fit
    if (node.properties['fit'] != null) {
      args['fit'] = refer(node.properties['fit'] as String);
    }

    // ClipBehavior
    if (node.properties['clipBehavior'] != null) {
      args['clipBehavior'] = refer(node.properties['clipBehavior'] as String);
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes);
        }).toList(),
      );
    }

    return refer('Stack').call([], args);
  }

  Expression _buildExpanded(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Flex
    if (node.properties['flex'] != null) {
      args['flex'] = literalNum(node.properties['flex'] as num);
    }

    // Child (required)
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('Expanded').call([], args);
  }

  Expression _buildFlexible(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Flex
    if (node.properties['flex'] != null) {
      args['flex'] = literalNum(node.properties['flex'] as num);
    }

    // Fit
    if (node.properties['fit'] != null) {
      args['fit'] = refer(node.properties['fit'] as String);
    }

    // Child (required)
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('Flexible').call([], args);
  }

  Expression _buildPadding(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Padding
    if (node.properties['padding'] != null) {
      final paddingMap = node.properties['padding'] as Map<String, dynamic>;
      final top = paddingMap['top'] as num? ?? 0;
      final right = paddingMap['right'] as num? ?? 0;
      final bottom = paddingMap['bottom'] as num? ?? 0;
      final left = paddingMap['left'] as num? ?? 0;

      if (top == right && right == bottom && bottom == left) {
        // EdgeInsets.all
        args['padding'] = refer('EdgeInsets').property('all').call([
          literalNum(top),
        ]);
      } else {
        // EdgeInsets.only
        final onlyArgs = <String, Expression>{};
        if (top != 0) onlyArgs['top'] = literalNum(top);
        if (right != 0) onlyArgs['right'] = literalNum(right);
        if (bottom != 0) onlyArgs['bottom'] = literalNum(bottom);
        if (left != 0) onlyArgs['left'] = literalNum(left);
        args['padding'] = refer('EdgeInsets').property('only').call(
          [],
          onlyArgs,
        );
      }
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('Padding').call([], args);
  }

  Expression _buildCenter(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Width factor
    if (node.properties['widthFactor'] != null) {
      args['widthFactor'] = literalNum(node.properties['widthFactor'] as num);
    }

    // Height factor
    if (node.properties['heightFactor'] != null) {
      args['heightFactor'] = literalNum(node.properties['heightFactor'] as num);
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('Center').call([], args);
  }

  Expression _buildAlign(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // Alignment
    if (node.properties['alignment'] != null) {
      args['alignment'] = refer(node.properties['alignment'] as String);
    }

    // Width factor
    if (node.properties['widthFactor'] != null) {
      args['widthFactor'] = literalNum(node.properties['widthFactor'] as num);
    }

    // Height factor
    if (node.properties['heightFactor'] != null) {
      args['heightFactor'] = literalNum(node.properties['heightFactor'] as num);
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('Align').call([], args);
  }

  Expression _buildSpacer(WidgetNode node) {
    final args = <String, Expression>{};

    // Flex
    if (node.properties['flex'] != null) {
      args['flex'] = literalNum(node.properties['flex'] as num);
    }

    return refer('Spacer').call([], args);
  }

  // Phase 2 Task 10: Content widgets

  Expression _buildIcon(WidgetNode node) {
    final iconName = node.properties['icon'] as String? ?? 'Icons.star';
    final positionalArgs = [refer(iconName)];
    final args = <String, Expression>{};

    // Size
    if (node.properties['size'] != null) {
      args['size'] = literalNum(node.properties['size'] as num);
    }

    // Color
    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      args['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    return refer('Icon').call(positionalArgs, args);
  }

  Expression _buildImage(WidgetNode node) {
    // For now, generate a Container as placeholder since we don't have
    // actual image source. In a real implementation, this would be
    // Image.network or Image.asset based on source type.
    final args = <String, Expression>{};

    if (node.properties['width'] != null) {
      args['width'] = literalNum(node.properties['width'] as num);
    }

    if (node.properties['height'] != null) {
      args['height'] = literalNum(node.properties['height'] as num);
    }

    // Use placeholder color to indicate image location
    args['color'] = refer('Colors').property('grey').index(literalNum(300));

    return refer('Container').call([], args);
  }

  Expression _buildDivider(WidgetNode node) {
    final args = <String, Expression>{};

    // Thickness
    if (node.properties['thickness'] != null) {
      args['thickness'] = literalNum(node.properties['thickness'] as num);
    }

    // Indent
    if (node.properties['indent'] != null) {
      args['indent'] = literalNum(node.properties['indent'] as num);
    }

    // End indent
    if (node.properties['endIndent'] != null) {
      args['endIndent'] = literalNum(node.properties['endIndent'] as num);
    }

    // Color
    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      args['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    return refer('Divider').call([], args);
  }

  Expression _buildVerticalDivider(WidgetNode node) {
    final args = <String, Expression>{};

    // Thickness
    if (node.properties['thickness'] != null) {
      args['thickness'] = literalNum(node.properties['thickness'] as num);
    }

    // Width
    if (node.properties['width'] != null) {
      args['width'] = literalNum(node.properties['width'] as num);
    }

    // Indent
    if (node.properties['indent'] != null) {
      args['indent'] = literalNum(node.properties['indent'] as num);
    }

    // End indent
    if (node.properties['endIndent'] != null) {
      args['endIndent'] = literalNum(node.properties['endIndent'] as num);
    }

    // Color
    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      args['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    return refer('VerticalDivider').call([], args);
  }

  Expression _buildPlaceholder(WidgetNode node) {
    final args = <String, Expression>{};

    // Fallback width
    if (node.properties['fallbackWidth'] != null) {
      args['fallbackWidth'] =
          literalNum(node.properties['fallbackWidth'] as num);
    }

    // Fallback height
    if (node.properties['fallbackHeight'] != null) {
      args['fallbackHeight'] =
          literalNum(node.properties['fallbackHeight'] as num);
    }

    // Stroke width
    if (node.properties['strokeWidth'] != null) {
      args['strokeWidth'] = literalNum(node.properties['strokeWidth'] as num);
    }

    // Color
    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      args['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    return refer('Placeholder').call([], args);
  }

  // Phase 2 Task 11: Input widgets

  Expression _buildElevatedButton(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
  ) {
    final args = <String, Expression>{};

    // onPressed: enabled (true) = () {}, disabled (false) = null
    final enabled = node.properties['onPressed'] as bool? ?? true;
    if (enabled) {
      args['onPressed'] = const CodeExpression(Code('() {}'));
    } else {
      args['onPressed'] = literalNull;
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('ElevatedButton').call([], args);
  }

  Expression _buildTextButton(WidgetNode node, Map<String, WidgetNode> nodes) {
    final args = <String, Expression>{};

    // onPressed: enabled (true) = () {}, disabled (false) = null
    final enabled = node.properties['onPressed'] as bool? ?? true;
    if (enabled) {
      args['onPressed'] = const CodeExpression(Code('() {}'));
    } else {
      args['onPressed'] = literalNull;
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] = _buildWidgetExpression(childNode, nodes);
      }
    }

    return refer('TextButton').call([], args);
  }

  Expression _buildIconButton(WidgetNode node) {
    final args = <String, Expression>{};

    // Icon (required) - wrap in Icon widget
    final iconName = node.properties['icon'] as String? ?? 'Icons.add';
    args['icon'] = refer('Icon').call([refer(iconName)]);

    // Icon size
    if (node.properties['iconSize'] != null) {
      args['iconSize'] = literalNum(node.properties['iconSize'] as num);
    }

    // Color
    if (node.properties['color'] != null) {
      final colorValue = node.properties['color'] as int;
      args['color'] = refer('Color').call([
        literalNum(colorValue, radix: 16),
      ]);
    }

    // Tooltip
    if (node.properties['tooltip'] != null) {
      args['tooltip'] = literalString(node.properties['tooltip'] as String);
    }

    // onPressed: enabled (true) = () {}, disabled (false) = null
    final enabled = node.properties['onPressed'] as bool? ?? true;
    if (enabled) {
      args['onPressed'] = const CodeExpression(Code('() {}'));
    } else {
      args['onPressed'] = literalNull;
    }

    return refer('IconButton').call([], args);
  }
}

/// Creates a number literal with optional radix for hex values.
Expression literalNum(num value, {int? radix}) {
  if (radix == 16 && value is int) {
    return CodeExpression(Code('0x${value.toRadixString(16).toUpperCase()}'));
  }
  return literal(value);
}
