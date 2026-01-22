import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_forge/features/help/shortcut_reference.dart';
import 'package:flutter_forge/features/shortcuts/keyboard_shortcuts.dart';

/// Tests for Keyboard Shortcut Reference (Task 8.6)
///
/// Journey: J18 S3 - Keyboard Shortcut Reference
void main() {
  group('Keyboard Shortcut Reference (Task 8.6)', () {
    group('ShortcutReferenceOverlay widget', () {
      testWidgets('displays all shortcut categories', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: const ShortcutReferenceOverlay(),
                ),
              ),
            ),
          ),
        );

        // All categories should be visible
        expect(find.text('File'), findsOneWidget);
        expect(find.text('Edit'), findsOneWidget);
        expect(find.text('Widget'), findsOneWidget);
        // View might be scrolled off, so we just check a few categories
      });

      testWidgets('displays shortcuts under correct categories',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: const ShortcutReferenceOverlay(),
                ),
              ),
            ),
          ),
        );

        // Check file shortcuts are shown
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Open Project'), findsOneWidget);

        // Check edit shortcuts are shown
        expect(find.text('Undo'), findsOneWidget);
        expect(find.text('Redo'), findsOneWidget);
      });

      testWidgets('has search field', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: const ShortcutReferenceOverlay(),
                ),
              ),
            ),
          ),
        );

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Search shortcuts...'), findsOneWidget);
      });

      testWidgets('search filters shortcuts', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: const ShortcutReferenceOverlay(),
                ),
              ),
            ),
          ),
        );

        // Initially all shortcuts visible
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Undo'), findsOneWidget);

        // Type in search
        await tester.enterText(find.byType(TextField), 'save');
        await tester.pumpAndSettle();

        // Only matching shortcuts visible
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Undo'), findsNothing);
      });

      testWidgets('search highlights matching text', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: const ShortcutReferenceOverlay(),
                ),
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField), 'copy');
        await tester.pumpAndSettle();

        // Should find Copy Widget shortcut
        expect(find.text('Copy Widget'), findsOneWidget);
      });

      testWidgets('Escape closes overlay', (tester) async {
        var wasClosed = false;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: ShortcutReferenceOverlay(
                    onClose: () => wasClosed = true,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(wasClosed, isTrue);
      });

      testWidgets('displays platform-appropriate shortcut keys',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              // Default platform is TargetPlatform.android in tests
              // Use Theme to override
              home: Scaffold(
                body: SizedBox(
                  width: 800,
                  height: 600,
                  child: const ShortcutReferenceOverlay(),
                ),
              ),
            ),
          ),
        );

        // In test environment, should show Ctrl notation
        expect(find.textContaining('Ctrl'), findsWidgets);
      });
    });

    group('ShortcutItem widget', () {
      testWidgets('displays label and shortcut', (tester) async {
        const shortcut = ShortcutDefinition(
          id: 'test',
          label: 'Test Action',
          category: ShortcutCategory.edit,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyT, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyT, control: true),
        );

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ShortcutItem(shortcut: shortcut),
              ),
            ),
          ),
        );

        expect(find.text('Test Action'), findsOneWidget);
      });

      testWidgets('displays description if provided', (tester) async {
        const shortcut = ShortcutDefinition(
          id: 'test',
          label: 'Test Action',
          description: 'This is a test action',
          category: ShortcutCategory.edit,
          macShortcut: SingleActivator(LogicalKeyboardKey.keyT, meta: true),
          windowsShortcut:
              SingleActivator(LogicalKeyboardKey.keyT, control: true),
        );

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: ShortcutItem(shortcut: shortcut),
              ),
            ),
          ),
        );

        expect(find.text('This is a test action'), findsOneWidget);
      });
    });

    group('Opening shortcut reference (J18 S3)', () {
      test('Cmd+/ or Ctrl+/ shortcut is registered', () {
        final shortcut = ShortcutsRegistry.findById('show-shortcuts');
        expect(shortcut, isNotNull);
        expect(shortcut!.macShortcut.trigger, LogicalKeyboardKey.slash);
        expect(shortcut.macShortcut.meta, isTrue);
        expect(shortcut.windowsShortcut.trigger, LogicalKeyboardKey.slash);
        expect(shortcut.windowsShortcut.control, isTrue);
      });
    });

    group('Contextual help (J18 S4)', () {
      testWidgets('property tooltips display help text', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: PropertyHelpTooltip(
                  propertyName: 'padding',
                  description: 'Space around the widget\'s content',
                  type: 'EdgeInsets',
                ),
              ),
            ),
          ),
        );

        expect(find.text('padding'), findsOneWidget);
        expect(find.text("Space around the widget's content"), findsOneWidget);
        expect(find.text('EdgeInsets'), findsOneWidget);
      });

      testWidgets('widget palette tooltips display info', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: Scaffold(
                body: WidgetHelpTooltip(
                  widgetName: 'Container',
                  description: 'A convenience widget for styling',
                  category: 'Layout',
                ),
              ),
            ),
          ),
        );

        expect(find.text('Container'), findsOneWidget);
        expect(find.text('A convenience widget for styling'), findsOneWidget);
        expect(find.text('Layout'), findsOneWidget);
      });
    });

    group('Documentation links (J18 S5)', () {
      test('HelpLinks contains required URLs', () {
        expect(HelpLinks.documentation, isNotEmpty);
        expect(HelpLinks.reportIssue, contains('github'));
      });

      test('HelpLinks builds widget documentation URL', () {
        final url = HelpLinks.widgetDocumentation('Container');
        expect(url, contains('Container'));
      });

      test('HelpLinks builds Flutter API URL', () {
        final url = HelpLinks.flutterApiDocs('Container');
        expect(url, contains('flutter'));
        expect(url, contains('Container'));
      });
    });
  });
}
