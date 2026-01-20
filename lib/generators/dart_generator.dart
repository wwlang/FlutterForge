import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'package:flutter_forge/core/models/widget_node.dart';

/// Generates formatted Dart code from a WidgetNode tree.
///
/// Converts the visual widget tree into a StatelessWidget class
/// with proper Flutter code structure.
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
      default:
        throw ArgumentError('Unknown widget type: ${node.type}');
    }
  }

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
}

/// Creates a number literal with optional radix for hex values.
Expression literalNum(num value, {int? radix}) {
  if (radix == 16 && value is int) {
    return CodeExpression(Code('0x${value.toRadixString(16).toUpperCase()}'));
  }
  return literal(value);
}
