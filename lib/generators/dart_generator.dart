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
///
/// Phase 9 Task 9.1.1/9.1.2: Supports Dart 3.10 dot shorthand syntax when
/// `useDotShorthand` is enabled in `generate`.
class DartGenerator {
  /// Creates a DartGenerator.
  DartGenerator({DartFormatter? formatter})
      : _formatter = formatter ??
            DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);

  final DartFormatter _formatter;
  final _emitter = DartEmitter(useNullSafetySyntax: true);

  /// Types that support enum dot shorthand in Dart 3.10+.
  ///
  /// When the type can be inferred from context (constructor parameter),
  /// these can use `.value` instead of `TypeName.value`.
  static const _shorthandEnumTypes = {
    'MainAxisAlignment',
    'CrossAxisAlignment',
    'MainAxisSize',
    'TextAlign',
    'TextOverflow',
    'FontWeight',
    'FontStyle',
    'BoxFit',
    'Alignment',
    'AlignmentDirectional',
    'Axis',
    'VerticalDirection',
    'TextDirection',
    'Clip',
    'StackFit',
    'FlexFit',
    'WrapAlignment',
    'WrapCrossAlignment',
  };

  /// Types that support constructor dot shorthand in Dart 3.10+.
  ///
  /// These are static factory constructors that can use `.constructorName(...)`
  /// instead of `TypeName.constructorName(...)`.
  /// Note: These are handled specially in [_buildEdgeInsets] and
  /// [_buildBorderRadius], not via [_referWithShorthand].
  // ignore: unused_field
  static const _shorthandConstructorTypes = {
    'EdgeInsets',
    'EdgeInsetsDirectional',
    'BorderRadius',
  };

  /// Types that should NEVER use shorthand (require class prefix).
  static const _noShorthandTypes = {
    'Colors',
    'Icons',
    'Duration',
    'Offset',
    'Size',
    'Color', // Color constructor, not enum
  };

  /// Generates Dart code for the widget tree.
  ///
  /// Parameters:
  /// - [nodes]: Map of all widget nodes
  /// - [rootId]: ID of the root widget
  /// - [className]: Name for the generated widget class
  /// - [useDotShorthand]: If true, uses Dart 3.10+ dot shorthand syntax.
  ///   Defaults to false for backward compatibility.
  ///
  /// Returns formatted Dart code as a string.
  ///
  /// Note: When [useDotShorthand] is true, the output uses basic indentation
  /// instead of dart_style formatting because the formatter may not support
  /// the dot shorthand language feature yet.
  String generate({
    required Map<String, WidgetNode> nodes,
    required String rootId,
    required String className,
    bool useDotShorthand = false,
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
      useDotShorthand: useDotShorthand,
    );

    // Build the library
    final library = Library(
      (b) => b
        ..directives.add(
          Directive.import('package:flutter/material.dart'),
        )
        ..body.add(widgetClass),
    );

    // Generate code
    final code = library.accept(_emitter).toString();

    // When using shorthand, apply basic formatting instead of dart_style
    // because dart_style may not support the dot shorthand language feature
    // yet.
    if (useDotShorthand) {
      return _basicFormat(code);
    }

    return _formatter.format(code);
  }

  /// Applies basic formatting to code when dart_style cannot be used.
  ///
  /// This provides reasonable indentation and line breaks for readability
  /// while preserving Dart 3.10+ syntax features like dot shorthand.
  String _basicFormat(String code) {
    final buffer = StringBuffer();
    var indentLevel = 0;
    var inString = false;
    var stringChar = '';
    var lastChar = '';

    for (var i = 0; i < code.length; i++) {
      final char = code[i];

      // Track string state to avoid formatting inside strings
      if (!inString && (char == "'" || char == '"')) {
        inString = true;
        stringChar = char;
      } else if (inString && char == stringChar && lastChar != r'\') {
        inString = false;
      }

      if (inString) {
        buffer.write(char);
        lastChar = char;
        continue;
      }

      switch (char) {
        case '{':
          buffer
            ..write(char)
            ..writeln()
            ..write('  ' * (indentLevel + 1));
          indentLevel++;
        case '}':
          indentLevel--;
          buffer
            ..writeln()
            ..write('  ' * indentLevel)
            ..write(char);
        case ';':
          buffer.write(char);
          // Add newline after semicolons (except in for loops)
          if (!_isInForLoop(code, i)) {
            buffer
              ..writeln()
              ..write('  ' * indentLevel);
          }
        case ',':
          buffer.write(char);
          // Add newline after commas in multi-line contexts
          if (_shouldBreakAfterComma(code, i)) {
            buffer
              ..writeln()
              ..write('  ' * indentLevel);
          } else {
            buffer.write(' ');
          }
        default:
          // Skip redundant whitespace
          if (char == ' ' && (lastChar == ' ' || lastChar == '\n')) {
            continue;
          }
          if (char == '\n' && lastChar == '\n') {
            continue;
          }
          buffer.write(char);
      }
      lastChar = char;
    }

    return buffer.toString().trim();
  }

  bool _isInForLoop(String code, int position) {
    // Simple check: look backward for 'for' followed by '('
    final preceding = code.substring(0, position);
    final lastFor = preceding.lastIndexOf('for');
    if (lastFor == -1) return false;

    final lastSemi = preceding.lastIndexOf(';');
    if (lastSemi > lastFor) {
      // Check if we're inside the for statement
      final parenCount = preceding.substring(lastFor).split('(').length -
          preceding.substring(lastFor).split(')').length;
      return parenCount > 0;
    }
    return false;
  }

  bool _shouldBreakAfterComma(String code, int position) {
    // Break after comma if we're in a parameter list or children list
    // Simple heuristic: break if there's a colon before the next comma
    // or closing bracket
    final remaining = code.substring(position + 1);
    final nextComma = remaining.indexOf(',');
    final nextClose = remaining.indexOf(')');
    final nextBracket = remaining.indexOf(']');
    final nextColon = remaining.indexOf(':');

    final endPos = [nextComma, nextClose, nextBracket]
        .where((p) => p >= 0)
        .fold<int?>(null, (min, p) => min == null ? p : (p < min ? p : min));

    return endPos != null && nextColon >= 0 && nextColon < endPos;
  }

  Class _buildWidgetClass({
    required String className,
    required Map<String, WidgetNode> nodes,
    required WidgetNode rootNode,
    required bool useDotShorthand,
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
                _buildWidgetExpression(rootNode, nodes, useDotShorthand).code,
                const Code(';'),
              ]),
          ),
        ),
    );
  }

  Expression _buildWidgetExpression(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    switch (node.type) {
      // Phase 1 widgets
      case 'Container':
        return _buildContainer(node, nodes, useDotShorthand);
      case 'Text':
        return _buildText(node, useDotShorthand);
      case 'Row':
        return _buildRow(node, nodes, useDotShorthand);
      case 'Column':
        return _buildColumn(node, nodes, useDotShorthand);
      case 'SizedBox':
        return _buildSizedBox(node, nodes, useDotShorthand);

      // Phase 2 Task 9: Layout widgets
      case 'Stack':
        return _buildStack(node, nodes, useDotShorthand);
      case 'Expanded':
        return _buildExpanded(node, nodes, useDotShorthand);
      case 'Flexible':
        return _buildFlexible(node, nodes, useDotShorthand);
      case 'Padding':
        return _buildPadding(node, nodes, useDotShorthand);
      case 'Center':
        return _buildCenter(node, nodes, useDotShorthand);
      case 'Align':
        return _buildAlign(node, nodes, useDotShorthand);
      case 'Spacer':
        return _buildSpacer(node);

      // Phase 2 Task 10: Content widgets
      case 'Icon':
        return _buildIcon(node);
      case 'Image':
        return _buildImage(node, useDotShorthand);
      case 'Divider':
        return _buildDivider(node);
      case 'VerticalDivider':
        return _buildVerticalDivider(node);
      case 'Placeholder':
        return _buildPlaceholder(node);

      // Phase 2 Task 11: Input widgets
      case 'ElevatedButton':
        return _buildElevatedButton(node, nodes, useDotShorthand);
      case 'TextButton':
        return _buildTextButton(node, nodes, useDotShorthand);
      case 'IconButton':
        return _buildIconButton(node);

      // Phase 6: Additional widgets
      case 'Wrap':
        return _buildWrap(node, nodes, useDotShorthand);

      default:
        throw ArgumentError('Unknown widget type: ${node.type}');
    }
  }

  /// Converts a fully qualified enum value to dot shorthand if applicable.
  ///
  /// Example: 'MainAxisAlignment.center' -> '.center' (when shorthand enabled)
  ///
  /// Returns the original value if shorthand is disabled or type is excluded.
  Expression _referWithShorthand(String value, bool useDotShorthand) {
    if (!useDotShorthand) {
      return refer(value);
    }

    // Check if value contains a dot (TypeName.value format)
    final dotIndex = value.indexOf('.');
    if (dotIndex == -1) {
      return refer(value);
    }

    final typeName = value.substring(0, dotIndex);
    final valueName = value.substring(dotIndex + 1);

    // Check if this type should NOT use shorthand
    if (_noShorthandTypes.contains(typeName)) {
      return refer(value);
    }

    // Check if this type supports enum shorthand
    if (_shorthandEnumTypes.contains(typeName)) {
      // Return shorthand: .valueName
      return CodeExpression(Code('.$valueName'));
    }

    // Default: return full reference
    return refer(value);
  }

  /// Builds an EdgeInsets expression, using shorthand if enabled.
  Expression _buildEdgeInsets(
    Map<String, dynamic> paddingMap,
    bool useDotShorthand,
  ) {
    final top = paddingMap['top'] as num? ?? 0;
    final right = paddingMap['right'] as num? ?? 0;
    final bottom = paddingMap['bottom'] as num? ?? 0;
    final left = paddingMap['left'] as num? ?? 0;

    // Determine the most appropriate EdgeInsets constructor
    if (top == right && right == bottom && bottom == left) {
      // EdgeInsets.all
      if (useDotShorthand) {
        return CodeExpression(Code('.all(${_formatNum(top)})'));
      }
      return refer('EdgeInsets').property('all').call([literalNum(top)]);
    }

    // Check for symmetric pattern
    if (top == bottom && left == right) {
      if (useDotShorthand) {
        if (top == 0) {
          return CodeExpression(
            Code('.symmetric(horizontal: ${_formatNum(left)})'),
          );
        } else if (left == 0) {
          return CodeExpression(
            Code('.symmetric(vertical: ${_formatNum(top)})'),
          );
        }
        return CodeExpression(
          Code(
            '.symmetric(horizontal: ${_formatNum(left)}, '
            'vertical: ${_formatNum(top)})',
          ),
        );
      }
      final symmetricArgs = <String, Expression>{};
      if (left != 0) symmetricArgs['horizontal'] = literalNum(left);
      if (top != 0) symmetricArgs['vertical'] = literalNum(top);
      return refer('EdgeInsets').property('symmetric').call([], symmetricArgs);
    }

    // EdgeInsets.only
    final onlyParts = <String>[];
    if (top != 0) onlyParts.add('top: ${_formatNum(top)}');
    if (right != 0) onlyParts.add('right: ${_formatNum(right)}');
    if (bottom != 0) onlyParts.add('bottom: ${_formatNum(bottom)}');
    if (left != 0) onlyParts.add('left: ${_formatNum(left)}');

    if (useDotShorthand) {
      return CodeExpression(Code('.only(${onlyParts.join(', ')})'));
    }

    final onlyArgs = <String, Expression>{};
    if (top != 0) onlyArgs['top'] = literalNum(top);
    if (right != 0) onlyArgs['right'] = literalNum(right);
    if (bottom != 0) onlyArgs['bottom'] = literalNum(bottom);
    if (left != 0) onlyArgs['left'] = literalNum(left);
    return refer('EdgeInsets').property('only').call([], onlyArgs);
  }

  /// Builds a BorderRadius expression, using shorthand if enabled.
  Expression _buildBorderRadius(
    Map<String, dynamic> radiusMap,
    bool useDotShorthand,
  ) {
    final type = radiusMap['type'] as String? ?? 'circular';
    final radius = radiusMap['radius'] as num? ?? 0;

    if (type == 'circular') {
      if (useDotShorthand) {
        return CodeExpression(Code('.circular(${_formatNum(radius)})'));
      }
      return refer('BorderRadius')
          .property('circular')
          .call([literalNum(radius)]);
    }

    if (type == 'all') {
      if (useDotShorthand) {
        return CodeExpression(
          Code('.all(Radius.circular(${_formatNum(radius)}))'),
        );
      }
      return refer('BorderRadius').property('all').call([
        refer('Radius').property('circular').call([literalNum(radius)]),
      ]);
    }

    // Default to circular
    if (useDotShorthand) {
      return CodeExpression(Code('.circular(${_formatNum(radius)})'));
    }
    return refer('BorderRadius')
        .property('circular')
        .call([literalNum(radius)]);
  }

  /// Formats a number for code output.
  String _formatNum(num value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  // Phase 1 widgets

  Expression _buildContainer(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
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

    // BorderRadius
    if (node.properties['borderRadius'] != null) {
      final radiusMap = node.properties['borderRadius'] as Map<String, dynamic>;
      args['decoration'] = refer('BoxDecoration').call([], {
        'borderRadius': _buildBorderRadius(radiusMap, useDotShorthand),
      });
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('Container').call([], args);
  }

  Expression _buildText(WidgetNode node, bool useDotShorthand) {
    final data = node.properties['data'] as String? ?? '';
    final positionalArgs = [literalString(data)];
    final namedArgs = <String, Expression>{};

    // TextAlign
    if (node.properties['textAlign'] != null) {
      namedArgs['textAlign'] = _referWithShorthand(
        node.properties['textAlign'] as String,
        useDotShorthand,
      );
    }

    // TextOverflow
    if (node.properties['overflow'] != null) {
      namedArgs['overflow'] = _referWithShorthand(
        node.properties['overflow'] as String,
        useDotShorthand,
      );
    }

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

    if (node.properties['fontWeight'] != null) {
      styleArgs['fontWeight'] = _referWithShorthand(
        node.properties['fontWeight'] as String,
        useDotShorthand,
      );
    }

    if (node.properties['fontStyle'] != null) {
      styleArgs['fontStyle'] = _referWithShorthand(
        node.properties['fontStyle'] as String,
        useDotShorthand,
      );
    }

    if (styleArgs.isNotEmpty) {
      namedArgs['style'] = refer('TextStyle').call([], styleArgs);
    }

    return refer('Text').call(positionalArgs, namedArgs);
  }

  Expression _buildRow(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // MainAxisAlignment
    if (node.properties['mainAxisAlignment'] != null) {
      args['mainAxisAlignment'] = _referWithShorthand(
        node.properties['mainAxisAlignment'] as String,
        useDotShorthand,
      );
    }

    // CrossAxisAlignment
    if (node.properties['crossAxisAlignment'] != null) {
      args['crossAxisAlignment'] = _referWithShorthand(
        node.properties['crossAxisAlignment'] as String,
        useDotShorthand,
      );
    }

    // MainAxisSize
    if (node.properties['mainAxisSize'] != null) {
      args['mainAxisSize'] = _referWithShorthand(
        node.properties['mainAxisSize'] as String,
        useDotShorthand,
      );
    }

    // TextDirection
    if (node.properties['textDirection'] != null) {
      args['textDirection'] = _referWithShorthand(
        node.properties['textDirection'] as String,
        useDotShorthand,
      );
    }

    // VerticalDirection
    if (node.properties['verticalDirection'] != null) {
      args['verticalDirection'] = _referWithShorthand(
        node.properties['verticalDirection'] as String,
        useDotShorthand,
      );
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes, useDotShorthand);
        }).toList(),
      );
    }

    return refer('Row').call([], args);
  }

  Expression _buildColumn(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // MainAxisAlignment
    if (node.properties['mainAxisAlignment'] != null) {
      args['mainAxisAlignment'] = _referWithShorthand(
        node.properties['mainAxisAlignment'] as String,
        useDotShorthand,
      );
    }

    // CrossAxisAlignment
    if (node.properties['crossAxisAlignment'] != null) {
      args['crossAxisAlignment'] = _referWithShorthand(
        node.properties['crossAxisAlignment'] as String,
        useDotShorthand,
      );
    }

    // MainAxisSize
    if (node.properties['mainAxisSize'] != null) {
      args['mainAxisSize'] = _referWithShorthand(
        node.properties['mainAxisSize'] as String,
        useDotShorthand,
      );
    }

    // VerticalDirection
    if (node.properties['verticalDirection'] != null) {
      args['verticalDirection'] = _referWithShorthand(
        node.properties['verticalDirection'] as String,
        useDotShorthand,
      );
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes, useDotShorthand);
        }).toList(),
      );
    }

    return refer('Column').call([], args);
  }

  Expression _buildSizedBox(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
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
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('SizedBox').call([], args);
  }

  // Phase 2 Task 9: Layout widgets

  Expression _buildStack(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // Alignment
    if (node.properties['alignment'] != null) {
      args['alignment'] = _referWithShorthand(
        node.properties['alignment'] as String,
        useDotShorthand,
      );
    }

    // Fit
    if (node.properties['fit'] != null) {
      args['fit'] = _referWithShorthand(
        node.properties['fit'] as String,
        useDotShorthand,
      );
    }

    // ClipBehavior
    if (node.properties['clipBehavior'] != null) {
      args['clipBehavior'] = _referWithShorthand(
        node.properties['clipBehavior'] as String,
        useDotShorthand,
      );
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes, useDotShorthand);
        }).toList(),
      );
    }

    return refer('Stack').call([], args);
  }

  Expression _buildExpanded(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // Flex
    if (node.properties['flex'] != null) {
      args['flex'] = literalNum(node.properties['flex'] as num);
    }

    // Child (required)
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('Expanded').call([], args);
  }

  Expression _buildFlexible(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // Flex
    if (node.properties['flex'] != null) {
      args['flex'] = literalNum(node.properties['flex'] as num);
    }

    // Fit
    if (node.properties['fit'] != null) {
      args['fit'] = _referWithShorthand(
        node.properties['fit'] as String,
        useDotShorthand,
      );
    }

    // Child (required)
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('Flexible').call([], args);
  }

  Expression _buildPadding(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // Padding
    if (node.properties['padding'] != null) {
      final paddingMap = node.properties['padding'] as Map<String, dynamic>;
      args['padding'] = _buildEdgeInsets(paddingMap, useDotShorthand);
    }

    // Child
    if (node.childrenIds.isNotEmpty) {
      final childNode = nodes[node.childrenIds.first];
      if (childNode != null) {
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('Padding').call([], args);
  }

  Expression _buildCenter(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
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
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('Center').call([], args);
  }

  Expression _buildAlign(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // Alignment
    if (node.properties['alignment'] != null) {
      args['alignment'] = _referWithShorthand(
        node.properties['alignment'] as String,
        useDotShorthand,
      );
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
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
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

  Expression _buildImage(WidgetNode node, bool useDotShorthand) {
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

    // BoxFit
    if (node.properties['fit'] != null) {
      args['fit'] = _referWithShorthand(
        node.properties['fit'] as String,
        useDotShorthand,
      );
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
    bool useDotShorthand,
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
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
      }
    }

    return refer('ElevatedButton').call([], args);
  }

  Expression _buildTextButton(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
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
        args['child'] =
            _buildWidgetExpression(childNode, nodes, useDotShorthand);
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

  // Phase 6: Additional widgets

  Expression _buildWrap(
    WidgetNode node,
    Map<String, WidgetNode> nodes,
    bool useDotShorthand,
  ) {
    final args = <String, Expression>{};

    // Direction (Axis)
    if (node.properties['direction'] != null) {
      args['direction'] = _referWithShorthand(
        node.properties['direction'] as String,
        useDotShorthand,
      );
    }

    // Alignment (WrapAlignment)
    if (node.properties['alignment'] != null) {
      args['alignment'] = _referWithShorthand(
        node.properties['alignment'] as String,
        useDotShorthand,
      );
    }

    // Spacing
    if (node.properties['spacing'] != null) {
      args['spacing'] = literalNum(node.properties['spacing'] as num);
    }

    // Run spacing
    if (node.properties['runSpacing'] != null) {
      args['runSpacing'] = literalNum(node.properties['runSpacing'] as num);
    }

    // Children
    if (node.childrenIds.isNotEmpty) {
      args['children'] = literalList(
        node.childrenIds.map((id) {
          final childNode = nodes[id];
          if (childNode == null) {
            throw ArgumentError('Child node not found: $id');
          }
          return _buildWidgetExpression(childNode, nodes, useDotShorthand);
        }).toList(),
      );
    }

    return refer('Wrap').call([], args);
  }
}

/// Creates a number literal with optional radix for hex values.
Expression literalNum(num value, {int? radix}) {
  if (radix == 16 && value is int) {
    return CodeExpression(Code('0x${value.toRadixString(16).toUpperCase()}'));
  }
  return literal(value);
}
