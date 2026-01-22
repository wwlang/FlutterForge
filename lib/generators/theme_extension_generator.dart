import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'package:flutter_forge/core/models/design_token.dart';

/// Generates Flutter ThemeExtension classes from design tokens.
///
/// Converts design tokens into a type-safe ThemeExtension class with:
/// - Light and dark static instances
/// - copyWith method for modifications
/// - lerp method for animations
/// - Usage examples in comments
class ThemeExtensionGenerator {
  /// Creates a ThemeExtensionGenerator.
  ThemeExtensionGenerator({DartFormatter? formatter})
      : _formatter = formatter ??
            DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);

  final DartFormatter _formatter;
  final _emitter = DartEmitter(useNullSafetySyntax: true);

  /// Generates Dart code for a ThemeExtension class.
  ///
  /// Parameters:
  /// - [tokens]: List of design tokens to include
  /// - [extensionName]: Name for the generated extension class
  ///
  /// Returns formatted Dart code as a string.
  String generate({
    required List<DesignToken> tokens,
    required String extensionName,
  }) {
    // Filter out alias tokens - only include base tokens
    final baseTokens = tokens.where((t) => !t.isAlias).toList();

    // Build the extension class
    final extensionClass = _buildExtensionClass(
      extensionName: extensionName,
      tokens: baseTokens,
    );

    // Build the library with imports and usage comments
    final library = Library(
      (b) => b
        ..directives.addAll([
          Directive.import('package:flutter/material.dart'),
          Directive.import('dart:ui', show: const ['lerpDouble']),
        ])
        ..body.add(extensionClass),
    );

    // Generate and format code
    final code = library.accept(_emitter).toString();
    final formattedCode = _formatter.format(code);

    // Prepend usage comments
    return _addUsageComments(formattedCode, extensionName);
  }

  Class _buildExtensionClass({
    required String extensionName,
    required List<DesignToken> tokens,
  }) {
    return Class(
      (b) => b
        ..name = extensionName
        ..extend = refer('ThemeExtension<$extensionName>')
        ..fields.addAll(_buildFields(tokens))
        ..fields.addAll(_buildStaticInstances(extensionName, tokens))
        ..constructors.add(_buildConstructor(tokens))
        ..methods.add(_buildCopyWithMethod(extensionName, tokens))
        ..methods.add(_buildLerpMethod(extensionName, tokens)),
    );
  }

  Iterable<Field> _buildFields(List<DesignToken> tokens) {
    return tokens.map((token) {
      return Field(
        (b) => b
          ..modifier = FieldModifier.final$
          ..type = refer(_getDartType(token))
          ..name = token.name,
      );
    });
  }

  Iterable<Field> _buildStaticInstances(
    String extensionName,
    List<DesignToken> tokens,
  ) {
    return [
      // Light instance
      Field(
        (b) => b
          ..static = true
          ..modifier = FieldModifier.constant
          ..type = refer(extensionName)
          ..name = 'light'
          ..assignment = _buildInstanceExpression(
            extensionName,
            tokens,
            isDark: false,
          ).code,
      ),
      // Dark instance
      Field(
        (b) => b
          ..static = true
          ..modifier = FieldModifier.constant
          ..type = refer(extensionName)
          ..name = 'dark'
          ..assignment = _buildInstanceExpression(
            extensionName,
            tokens,
            isDark: true,
          ).code,
      ),
    ];
  }

  Constructor _buildConstructor(List<DesignToken> tokens) {
    return Constructor(
      (b) => b
        ..constant = true
        ..optionalParameters.addAll(
          tokens.map((token) {
            return Parameter(
              (p) => p
                ..name = token.name
                ..named = true
                ..toThis = true,
            );
          }),
        ),
    );
  }

  Method _buildCopyWithMethod(String extensionName, List<DesignToken> tokens) {
    final parameters = tokens.map((token) {
      return Parameter(
        (p) => p
          ..name = token.name
          ..named = true
          ..type = refer(_getDartType(token)),
      );
    });

    final namedArgs = <String, Expression>{};
    for (final token in tokens) {
      namedArgs[token.name] = CodeExpression(
        Code('${token.name} ?? this.${token.name}'),
      );
    }

    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = refer(extensionName)
        ..name = 'copyWith'
        ..optionalParameters.addAll(parameters)
        ..body = refer(extensionName).call([], namedArgs).returned.statement,
    );
  }

  Method _buildLerpMethod(String extensionName, List<DesignToken> tokens) {
    final lerpExpressions = <String, Expression>{};
    for (final token in tokens) {
      lerpExpressions[token.name] = _buildLerpExpression(token);
    }

    final returnStatement = refer(extensionName).call([], lerpExpressions);

    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..returns = refer(extensionName)
        ..name = 'lerp'
        ..requiredParameters.addAll([
          Parameter(
            (p) => p
              ..name = 'other'
              ..type = refer('ThemeExtension<$extensionName>?'),
          ),
          Parameter(
            (p) => p
              ..name = 't'
              ..type = refer('double'),
          ),
        ])
        ..body = Block.of([
          Code('if (other is! $extensionName) {\n'),
          const Code('  return this;\n'),
          const Code('}\n'),
          returnStatement.returned.statement,
        ]),
    );
  }

  Expression _buildLerpExpression(DesignToken token) {
    switch (token.type) {
      case TokenType.color:
        return CodeExpression(
          Code('Color.lerp(${token.name}, other.${token.name}, t)'),
        );
      case TokenType.spacing:
      case TokenType.radius:
        return CodeExpression(
          Code('lerpDouble(${token.name}, other.${token.name}, t)'),
        );
      case TokenType.typography:
        return CodeExpression(
          Code('TextStyle.lerp(${token.name}, other.${token.name}, t)'),
        );
    }
  }

  Expression _buildInstanceExpression(
    String extensionName,
    List<DesignToken> tokens, {
    required bool isDark,
  }) {
    final namedArgs = <String, Expression>{};

    for (final token in tokens) {
      namedArgs[token.name] = _buildTokenValueExpression(token, isDark: isDark);
    }

    return refer(extensionName).call([], namedArgs);
  }

  Expression _buildTokenValueExpression(
    DesignToken token, {
    required bool isDark,
  }) {
    switch (token.type) {
      case TokenType.color:
        final value = isDark
            ? (token.darkValue ?? token.lightValue) as int
            : token.lightValue as int;
        return refer('Color').call([
          CodeExpression(Code('0x${value.toRadixString(16).toUpperCase()}')),
        ]);

      case TokenType.spacing:
        final value = token.spacingValue ?? 0.0;
        return literal(value);

      case TokenType.radius:
        final value = token.radiusValue ?? 0.0;
        return literal(value);

      case TokenType.typography:
        return _buildTextStyleExpression(token.typography);
    }
  }

  Expression _buildTextStyleExpression(TypographyValue? typography) {
    if (typography == null) {
      return refer('TextStyle').constInstance([]);
    }

    final args = <String, Expression>{};

    if (typography.fontFamily != null) {
      args['fontFamily'] = literalString(typography.fontFamily!);
    }

    args['fontSize'] = literal(typography.fontSize);
    args['fontWeight'] =
        refer('FontWeight').property('w${typography.fontWeight}');
    args['height'] = literal(typography.lineHeight);

    if (typography.letterSpacing != 0.0) {
      args['letterSpacing'] = literal(typography.letterSpacing);
    }

    return refer('TextStyle').constInstance([], args);
  }

  String _getDartType(DesignToken token) {
    switch (token.type) {
      case TokenType.color:
        return 'Color?';
      case TokenType.spacing:
      case TokenType.radius:
        return 'double?';
      case TokenType.typography:
        return 'TextStyle?';
    }
  }

  String _addUsageComments(String code, String extensionName) {
    final usage = '''
/// Generated ThemeExtension for $extensionName.
///
/// Usage in ThemeData:
/// ```dart
/// ThemeData(
///   extensions: [
///     $extensionName.light, // or $extensionName.dark
///   ],
/// )
/// ```
///
/// Access from BuildContext:
/// ```dart
/// final colors = Theme.of(context).extension<$extensionName>();
/// ```

''';
    return usage + code;
  }
}
