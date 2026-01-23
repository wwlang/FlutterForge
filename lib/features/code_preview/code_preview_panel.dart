import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/features/code_preview/dart_version_indicator.dart';
import 'package:flutter_forge/generators/dart_generator.dart';
import 'package:flutter_forge/generators/theme_extension_generator.dart';
import 'package:flutter_forge/providers/code_settings_provider.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_forge/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Code preview panel showing generated Dart code with syntax highlighting.
///
/// Features:
/// - Live code generation from widget tree (J16-S2)
/// - Syntax highlighting for Dart code (J16-S3)
/// - Copy to clipboard functionality (J16-S4)
/// - Line numbers (J16-S1)
/// - Dart version targeting with shorthand support (J19-S3)
class CodePreviewPanel extends ConsumerWidget {
  /// Creates a code preview panel.
  const CodePreviewPanel({
    required this.generator,
    required this.themeGenerator,
    super.key,
  });

  /// The Dart code generator.
  final DartGenerator generator;

  /// The theme extension generator.
  final ThemeExtensionGenerator themeGenerator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectProvider);
    final designTokens = ref.watch(designTokensProvider);
    final codeSettings = ref.watch(codeSettingsProvider);
    final theme = Theme.of(context);

    if (projectState.rootIds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.code_off,
              size: 48,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No widgets to generate',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add widgets to see generated code',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    String widgetCode;
    try {
      widgetCode = generator.generate(
        nodes: projectState.nodes,
        rootId: projectState.rootIds.first,
        className: 'GeneratedWidget',
        useDotShorthand: codeSettings.effectiveShorthand,
      );
    } catch (e) {
      widgetCode = '// Error generating code: $e';
    }

    String? themeCode;
    if (designTokens.isNotEmpty) {
      try {
        themeCode = themeGenerator.generate(
          tokens: designTokens,
          extensionName: 'AppDesignTokens',
        );
      } catch (e) {
        themeCode = '// Error generating theme: $e';
      }
    }

    return DefaultTabController(
      length: themeCode != null ? 2 : 1,
      child: Column(
        children: [
          // Header with tabs and version indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Row(
              children: [
                if (themeCode != null) ...[
                  const Expanded(
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Widget'),
                        Tab(text: 'Theme'),
                      ],
                      labelPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ] else
                  const Spacer(),
                // Dart version indicator (J19 S3)
                const DartVersionIndicator(),
              ],
            ),
          ),
          Expanded(
            child: themeCode != null
                ? TabBarView(
                    children: [
                      SyntaxHighlightedCode(code: widgetCode),
                      SyntaxHighlightedCode(code: themeCode),
                    ],
                  )
                : SyntaxHighlightedCode(code: widgetCode),
          ),
          // Copy button
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      final code = themeCode != null
                          ? '$widgetCode\n\n$themeCode'
                          : widgetCode;
                      await Clipboard.setData(ClipboardData(text: code));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Code copied to clipboard'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy All'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays Dart code with syntax highlighting and line numbers.
class SyntaxHighlightedCode extends StatelessWidget {
  /// Creates a syntax highlighted code view.
  const SyntaxHighlightedCode({
    required this.code,
    super.key,
  });

  /// The code to display.
  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lines = code.split('\n');
    final isDark = theme.brightness == Brightness.dark;

    return ColoredBox(
      color: isDark
          ? theme.colorScheme.surfaceContainerLowest
          : const Color(0xFFFAFAFA),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surfaceContainerLow
                  : const Color(0xFFF0F0F0),
              border: Border(
                right: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                lines.length,
                (index) => SizedBox(
                  height: 21, // Match line height
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: theme.colorScheme.outline,
                      height: 1.75,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Code with syntax highlighting
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SelectableText.rich(
                  _highlightSyntax(code, theme, isDark),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: theme.colorScheme.onSurface,
                    height: 1.75,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Applies syntax highlighting to Dart code.
  TextSpan _highlightSyntax(String code, ThemeData theme, bool isDark) {
    final spans = <TextSpan>[];
    final lines = code.split('\n');

    // Color scheme for syntax highlighting
    final keywordColor = isDark
        ? const Color(0xFF569CD6) // Blue for dark theme
        : const Color(0xFF0000FF); // Blue for light theme
    final stringColor = isDark
        ? const Color(0xFFCE9178) // Orange for dark theme
        : const Color(0xFFA31515); // Red-brown for light theme
    final commentColor = isDark
        ? const Color(0xFF6A9955) // Green for dark theme
        : const Color(0xFF008000); // Green for light theme
    final numberColor = isDark
        ? const Color(0xFFB5CEA8) // Light green for dark theme
        : const Color(0xFF098658); // Teal for light theme
    final classColor = isDark
        ? const Color(0xFF4EC9B0) // Cyan for dark theme
        : const Color(0xFF267F99); // Teal for light theme
    final defaultColor = theme.colorScheme.onSurface;

    // Dart keywords
    final keywords = {
      'import',
      'class',
      'extends',
      'const',
      'final',
      'var',
      'return',
      'if',
      'else',
      'for',
      'while',
      'do',
      'switch',
      'case',
      'break',
      'continue',
      'default',
      'throw',
      'try',
      'catch',
      'finally',
      'new',
      'this',
      'super',
      'true',
      'false',
      'null',
      'void',
      'dynamic',
      'int',
      'double',
      'String',
      'bool',
      'List',
      'Map',
      'Set',
      'required',
      'late',
      'async',
      'await',
      'yield',
      '@override',
    };

    // Class names (common Flutter types)
    final classNames = {
      'Widget',
      'StatelessWidget',
      'StatefulWidget',
      'BuildContext',
      'Container',
      'Text',
      'TextStyle',
      'Row',
      'Column',
      'SizedBox',
      'Padding',
      'EdgeInsets',
      'Color',
      'Colors',
      'Icon',
      'Icons',
      'Center',
      'Align',
      'Alignment',
      'Stack',
      'Expanded',
      'Flexible',
      'Spacer',
      'Card',
      'Image',
      'Divider',
      'VerticalDivider',
      'Placeholder',
      'ElevatedButton',
      'TextButton',
      'IconButton',
      'TextField',
      'Checkbox',
      'Switch',
      'Slider',
      'ListView',
      'GridView',
      'SingleChildScrollView',
      'ListTile',
      'AppBar',
      'Scaffold',
      'Wrap',
      'MainAxisAlignment',
      'CrossAxisAlignment',
      'MainAxisSize',
      'TextAlign',
      'TextOverflow',
      'BoxFit',
      'Clip',
      'Axis',
      'WrapAlignment',
      'FontWeight',
      'StackFit',
      'FlexFit',
    };

    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];

      if (lineIndex > 0) {
        spans.add(const TextSpan(text: '\n'));
      }

      // Check for comment
      if (line.trimLeft().startsWith('//')) {
        spans.add(
          TextSpan(
            text: line,
            style: TextStyle(color: commentColor),
          ),
        );
        continue;
      }

      // Tokenize the line
      final tokens = _tokenizeLine(line);
      for (final token in tokens) {
        Color? color;

        if (keywords.contains(token)) {
          color = keywordColor;
        } else if (classNames.contains(token)) {
          color = classColor;
        } else if (token.startsWith("'") || token.startsWith('"')) {
          color = stringColor;
        } else if (RegExp(r'^0x[0-9A-Fa-f]+$').hasMatch(token) ||
            RegExp(r'^-?\d+\.?\d*$').hasMatch(token)) {
          color = numberColor;
        } else {
          color = defaultColor;
        }

        spans.add(
          TextSpan(
            text: token,
            style: TextStyle(color: color),
          ),
        );
      }
    }

    return TextSpan(children: spans);
  }

  /// Tokenizes a line of Dart code.
  List<String> _tokenizeLine(String line) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    var inString = false;
    String? stringChar;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];

      // Handle strings
      if (!inString && (char == "'" || char == '"')) {
        // Flush buffer before starting string
        if (buffer.isNotEmpty) {
          tokens.addAll(_splitTokens(buffer.toString()));
          buffer.clear();
        }
        inString = true;
        stringChar = char;
        buffer.write(char);
        continue;
      }

      if (inString) {
        buffer.write(char);
        if (char == stringChar && (i == 0 || line[i - 1] != r'\')) {
          // End of string
          tokens.add(buffer.toString());
          buffer.clear();
          inString = false;
          stringChar = null;
        }
        continue;
      }

      buffer.write(char);
    }

    // Flush remaining buffer
    if (buffer.isNotEmpty) {
      if (inString) {
        tokens.add(buffer.toString());
      } else {
        tokens.addAll(_splitTokens(buffer.toString()));
      }
    }

    return tokens;
  }

  /// Splits a token string into individual tokens.
  List<String> _splitTokens(String input) {
    final tokens = <String>[];
    final buffer = StringBuffer();

    for (var i = 0; i < input.length; i++) {
      final char = input[i];

      // Check for @override
      if (char == '@' && input.substring(i).startsWith('@override')) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add('@override');
        i += 8; // Skip 'override'
        continue;
      }

      if (_isWordChar(char)) {
        buffer.write(char);
      } else {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(char);
      }
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }

    return tokens;
  }

  bool _isWordChar(String char) {
    return RegExp('[a-zA-Z0-9_.]').hasMatch(char);
  }
}
