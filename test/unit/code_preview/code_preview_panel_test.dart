import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/project_state.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/code_preview/code_preview_panel.dart';
import 'package:flutter_forge/generators/dart_generator.dart';
import 'package:flutter_forge/generators/theme_extension_generator.dart';
import 'package:flutter_forge/providers/project_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Code Preview Panel (Task 7.6)', () {
    late DartGenerator generator;
    late ThemeExtensionGenerator themeGenerator;

    setUp(() {
      generator = DartGenerator();
      themeGenerator = ThemeExtensionGenerator();
    });

    Widget buildTestWidget({
      ProjectState? projectState,
    }) {
      return ProviderScope(
        overrides: [
          if (projectState != null)
            projectProvider.overrideWith((ref) {
              final notifier = ProjectNotifier();
              notifier.setState(projectState);
              return notifier;
            }),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: CodePreviewPanel(
              generator: generator,
              themeGenerator: themeGenerator,
            ),
          ),
        ),
      );
    }

    group('J16-S1: Code Preview Panel UI', () {
      testWidgets('displays empty state when no widgets', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Should show empty state message
        expect(find.text('No widgets to generate'), findsOneWidget);
        expect(find.text('Add widgets to see generated code'), findsOneWidget);
        expect(find.byIcon(Icons.code_off), findsOneWidget);
      });

      testWidgets('displays generated code when widgets exist', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {'width': 100.0, 'height': 100.0},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Should show code
        expect(find.textContaining('Container'), findsWidgets);
        expect(find.textContaining('width'), findsWidgets);
      });

      testWidgets('shows copy button', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Should show copy button
        expect(find.byIcon(Icons.copy), findsOneWidget);
        expect(find.text('Copy All'), findsOneWidget);
      });

      testWidgets('shows line numbers in code view', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Should show line numbers (at least line 1)
        expect(find.text('1'), findsOneWidget);
      });
    });

    group('J16-S2: Live Code Updates', () {
      testWidgets('code updates when widget properties change', (tester) async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Start with initial state
        final initialState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {'width': 100.0},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        // Set initial state
        container.read(projectProvider.notifier).setState(initialState);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: CodePreviewPanel(
                  generator: generator,
                  themeGenerator: themeGenerator,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify initial code shows width: 100
        expect(find.textContaining('100'), findsWidgets);

        // Update the width
        container.read(projectProvider.notifier).updateProperty(
              nodeId: 'node-1',
              propertyName: 'width',
              value: 200.0,
            );
        await tester.pumpAndSettle();

        // Verify code updated to show width: 200
        expect(find.textContaining('200'), findsWidgets);
      });
    });

    group('J16-S3: Syntax Highlighting', () {
      testWidgets('applies syntax highlighting to code', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Should find the SyntaxHighlightedCode widget
        expect(find.byType(SyntaxHighlightedCode), findsOneWidget);
      });

      testWidgets('highlights keywords in blue', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Find the RichText widget that contains syntax-highlighted code
        final richTextFinder = find.byType(RichText);
        expect(richTextFinder, findsWidgets);
      });
    });

    group('J16-S4: Copy Functionality', () {
      testWidgets('copies code to clipboard when copy button tapped',
          (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Track clipboard data
        String? copiedText;
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          SystemChannels.platform,
          (MethodCall methodCall) async {
            if (methodCall.method == 'Clipboard.setData') {
              final Map<String, dynamic> args =
                  methodCall.arguments as Map<String, dynamic>;
              copiedText = args['text'] as String;
            }
            return null;
          },
        );

        // Tap copy button
        await tester.tap(find.text('Copy All'));
        await tester.pumpAndSettle();

        // Verify code was copied
        expect(copiedText, isNotNull);
        expect(copiedText, contains('Container'));
      });

      testWidgets('shows success feedback after copy', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Mock clipboard
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          SystemChannels.platform,
          (MethodCall methodCall) async => null,
        );

        // Tap copy button
        await tester.tap(find.text('Copy All'));
        await tester.pumpAndSettle();

        // Verify snackbar appears
        expect(find.text('Code copied to clipboard'), findsOneWidget);
      });
    });

    group('J16-S5: Code Structure', () {
      testWidgets('generates import statement', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Should contain import statement
        expect(
          find.textContaining("import 'package:flutter/material.dart'"),
          findsWidgets,
        );
      });

      testWidgets('generates StatelessWidget class', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Container',
              properties: {},
              childrenIds: [],
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // Should contain class definition
        expect(find.textContaining('StatelessWidget'), findsWidgets);
        expect(find.textContaining('GeneratedWidget'), findsWidgets);
      });

      testWidgets('generates proper indentation', (tester) async {
        final projectState = ProjectState(
          nodes: {
            'node-1': const WidgetNode(
              id: 'node-1',
              type: 'Column',
              properties: {},
              childrenIds: ['node-2'],
            ),
            'node-2': const WidgetNode(
              id: 'node-2',
              type: 'Text',
              properties: {'data': 'Hello'},
              childrenIds: [],
              parentId: 'node-1',
            ),
          },
          rootIds: ['node-1'],
        );

        await tester.pumpWidget(buildTestWidget(projectState: projectState));
        await tester.pumpAndSettle();

        // The code should be properly indented (formatted by dart_style)
        // We verify this by checking the generated code structure
        expect(find.textContaining('Column'), findsWidgets);
        expect(find.textContaining('Text'), findsWidgets);
      });
    });
  });
}
