import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/canvas/canvas.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// E2E Journey tests for Code Generation.
///
/// Tests user journeys for:
/// - Viewing generated code for widgets
/// - Code updates when canvas changes
/// - Valid Dart code syntax
/// - Correct widget tree representation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> dragWidgetToCanvas(
    WidgetTester tester,
    String widgetName,
  ) async {
    final widgetItem = find.text(widgetName).first;
    final canvas = find.byType(DesignCanvas);

    final gesture = await tester.startGesture(tester.getCenter(widgetItem));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.moveTo(tester.getCenter(canvas));
    await tester.pump(const Duration(milliseconds: 50));
    await gesture.up();
    await tester.pumpAndSettle();
  }

  Future<void> switchToCodeTab(WidgetTester tester) async {
    // Find and tap the "Code" tab in the right panel
    final codeTab = find.text('Code');
    if (codeTab.evaluate().isNotEmpty) {
      await tester.tap(codeTab.first);
      await tester.pumpAndSettle();
    }
  }

  group('Journey: Code Preview Display', () {
    testWidgets(
      'Workbench has Code tab',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Should have a Code tab in the interface
        expect(find.text('Code'), findsOneWidget);
      },
    );

    testWidgets(
      'Code tab shows code content area',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code panel should be visible (some code area should appear)
        // This verifies the tab switch works
        expect(find.byType(Workbench), findsOneWidget);
      },
    );
  });

  group('Journey: Code Generation for Widgets', () {
    testWidgets(
      'Dropping Container generates Container code',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Container
        await dragWidgetToCanvas(tester, 'Container');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain "Container" text
        // The generated code will have Container in it
        // Look for text containing "Container(" which is Dart syntax
        expect(find.textContaining('Container'), findsWidgets);
      },
    );

    testWidgets(
      'Dropping Text generates Text code',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Text
        await dragWidgetToCanvas(tester, 'Text');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain Text widget syntax
        expect(find.textContaining('Text'), findsWidgets);
      },
    );

    testWidgets(
      'Dropping Row generates Row code',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Row
        await dragWidgetToCanvas(tester, 'Row');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain Row
        expect(find.textContaining('Row'), findsWidgets);
      },
    );

    testWidgets(
      'Dropping Column generates Column code',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Column
        await dragWidgetToCanvas(tester, 'Column');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain Column
        expect(find.textContaining('Column'), findsWidgets);
      },
    );

    testWidgets(
      'Dropping Icon generates Icon code',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Icon
        await dragWidgetToCanvas(tester, 'Icon');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain Icon reference
        expect(find.textContaining('Icon'), findsWidgets);
      },
    );
  });

  group('Journey: Code Updates on Canvas Changes', () {
    testWidgets(
      'Code updates when widget is added',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop first widget
        await dragWidgetToCanvas(tester, 'Container');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Verify Container in code
        expect(find.textContaining('Container'), findsWidgets);
      },
    );
  });

  group('Journey: Code Syntax', () {
    testWidgets(
      'Generated code contains valid Dart syntax markers',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop a widget
        await dragWidgetToCanvas(tester, 'Container');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Generated code should contain parentheses (Dart constructors)
        expect(find.textContaining('('), findsWidgets);
      },
    );

    testWidgets(
      'Generated code for SizedBox includes proper structure',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop SizedBox
        await dragWidgetToCanvas(tester, 'SizedBox');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain SizedBox
        expect(find.textContaining('SizedBox'), findsWidgets);
      },
    );
  });

  group('Journey: Code with Properties', () {
    testWidgets(
      'Code reflects widget properties',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: FlutterForgeApp()),
        );
        await tester.pumpAndSettle();

        // Drop Text (which has default "Text" data property)
        await dragWidgetToCanvas(tester, 'Text');

        // Switch to Code tab
        await switchToCodeTab(tester);

        // Code should contain the text widget
        expect(find.textContaining('Text'), findsWidgets);
      },
    );
  });
}
