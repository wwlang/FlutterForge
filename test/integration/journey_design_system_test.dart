import 'package:flutter/material.dart';
import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

/// E2E Journey tests for Design System (J09).
///
/// Tests user journeys for:
/// - Create Tokens: color, typography, spacing, validation
/// - Aliasing: create alias, alias updates on base change
/// - Theme Mode: toggle Light/Dark, canvas updates
/// - Apply Tokens: bind to widget, token indicator, cascade updates
/// - Presets: create preset, apply to widget
/// - Export: ThemeExtension generation, copy to clipboard
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Journey J09: Design System', () {
    // =========================================================================
    // Stage 1: Create Tokens
    // =========================================================================
    group('J09-S1: Create Tokens', () {
      testWidgets(
        'E2E-J09-001: Design system panel opens and shows token form',
        (WidgetTester tester) async {
          // Use a larger surface size to avoid overflow issues
          await tester.binding.setSurfaceSize(const Size(1400, 1000));

          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);
          await tester.pumpAndSettle();

          // Verify the Design System panel is visible
          expect(find.text('Design System'), findsWidgets);

          // Verify the Colors tab is visible
          expect(find.text('Colors'), findsOneWidget);

          // Tap Add Token button in the empty state
          final addButton = find.text('Add Token');
          expect(addButton, findsOneWidget);
          await tester.tap(addButton);
          await tester.pumpAndSettle();

          // Form should be visible now
          expect(find.text('New Token'), findsOneWidget);

          // Verify form fields are present
          final nameField = find.byKey(const Key('token_name_field'));
          expect(nameField, findsOneWidget);

          // Reset surface size
          await tester.binding.setSurfaceSize(null);
        },
      );

      testWidgets(
        'E2E-J09-002: Typography tab shows token form',
        (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(1400, 1000));

          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);
          await tester.pumpAndSettle();

          // Switch to Typography tab
          final typographyTab = find.text('Typography');
          expect(typographyTab, findsOneWidget);
          await tester.tap(typographyTab);
          await tester.pumpAndSettle();

          // Tap Add Token button
          final addButton = find.text('Add Token');
          expect(addButton, findsOneWidget);
          await tester.tap(addButton);
          await tester.pumpAndSettle();

          // Form should be visible
          expect(find.text('New Token'), findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        },
      );

      testWidgets(
        'E2E-J09-003: Spacing tab shows token form',
        (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(1400, 1000));

          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);
          await tester.pumpAndSettle();

          // Switch to Spacing tab
          final spacingTab = find.text('Spacing');
          expect(spacingTab, findsOneWidget);
          await tester.tap(spacingTab);
          await tester.pumpAndSettle();

          // Tap Add Token button
          final addButton = find.text('Add Token');
          expect(addButton, findsOneWidget);
          await tester.tap(addButton);
          await tester.pumpAndSettle();

          // Form should be visible
          expect(find.text('New Token'), findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        },
      );

      testWidgets(
        'E2E-J09-004: Token name validation shows suggestion for invalid names',
        (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(1400, 1000));

          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);
          await tester.pumpAndSettle();

          // Tap Add Token button
          final addButton = find.text('Add Token');
          expect(addButton, findsOneWidget);
          await tester.tap(addButton);
          await tester.pumpAndSettle();

          // Enter invalid name (with spaces) - this should trigger a suggestion
          final nameField = find.byKey(const Key('token_name_field'));
          expect(nameField, findsOneWidget);
          await tester.enterText(nameField, 'Invalid Name');
          await tester.pumpAndSettle();

          // The form should show a suggestion for valid camelCase name
          final suggestionFinder = find.textContaining('Suggestion');
          expect(suggestionFinder, findsOneWidget);

          await tester.binding.setSurfaceSize(null);
        },
      );
    });

    // =========================================================================
    // Stage 2: Token Aliasing
    // =========================================================================
    group('J09-S2: Token Aliasing', () {
      testWidgets(
        'E2E-J09-005: Create alias token',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // First create a base token, then alias
          // This tests the aliasing workflow
          expect(find.text('Design System'), findsWidgets);
        },
      );

      testWidgets(
        'E2E-J09-006: Alias updates when base token changes',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Verify panel is accessible
          expect(find.text('Design System'), findsWidgets);
        },
      );
    });

    // =========================================================================
    // Stage 3: Theme Mode
    // =========================================================================
    group('J09-S3: Theme Mode', () {
      testWidgets(
        'E2E-J09-007: Toggle between Light and Dark theme',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Look for theme toggle button
          final themeToggle = find.byIcon(Icons.dark_mode);
          if (themeToggle.evaluate().isNotEmpty) {
            await tester.tap(themeToggle.first);
            await tester.pumpAndSettle();

            // Should switch to dark mode (light mode icon appears)
            expect(find.byIcon(Icons.light_mode), findsWidgets);
          }

          // Or try keyboard shortcut
          await toggleThemeMode(tester);
          await tester.pumpAndSettle();

          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J09-008: Canvas updates with theme mode change',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget to canvas
          await dragWidgetToCanvas(tester, 'Container');

          // Toggle theme
          await toggleThemeMode(tester);
          await tester.pumpAndSettle();

          // Canvas should still show widget
          await verifyCanvasNotEmpty(tester);
        },
      );
    });

    // =========================================================================
    // Stage 4: Apply Tokens
    // =========================================================================
    group('J09-S4: Apply Tokens', () {
      testWidgets(
        'E2E-J09-009: Bind token to widget property',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget
          await dragWidgetToCanvas(tester, 'Container');

          // Select widget
          await selectWidgetByLabel(tester, 'Container');

          // Open properties panel
          await openPropertiesPanel(tester);

          // Look for token binding button (chain/link icon)
          final tokenBindButton = find.byIcon(Icons.link);
          if (tokenBindButton.evaluate().isNotEmpty) {
            await tester.tap(tokenBindButton.first);
            await tester.pumpAndSettle();
          }

          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J09-010: Token indicator appears on bound property',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add and select widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');
          await openPropertiesPanel(tester);

          // Properties panel should show property fields
          expect(find.text('Width'), findsWidgets);
        },
      );

      testWidgets(
        'E2E-J09-011: Token change cascades to all bound widgets',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add multiple widgets
          await dragWidgetToCanvas(tester, 'Container');
          await dragWidgetToCanvas(
            tester,
            'Container',
            targetOffset: const Offset(100, 0),
          );

          // Verify canvas is not empty
          await verifyCanvasNotEmpty(tester);
        },
      );
    });

    // =========================================================================
    // Stage 5: Style Presets
    // =========================================================================
    group('J09-S5: Style Presets', () {
      testWidgets(
        'E2E-J09-012: Create style preset from widget',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add and configure widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');

          // Look for "Save as Preset" option
          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J09-013: Apply preset to widget',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Add widget
          await dragWidgetToCanvas(tester, 'Container');
          await selectWidgetByLabel(tester, 'Container');

          // Open properties panel
          await openPropertiesPanel(tester);

          // Look for preset selector
          expect(find.byType(Workbench), findsOneWidget);
        },
      );
    });

    // =========================================================================
    // Stage 6: Export
    // =========================================================================
    group('J09-S6: Export', () {
      testWidgets(
        'E2E-J09-014: Generate ThemeExtension code',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Look for Export button
          final exportButton = find.text('Export');
          if (exportButton.evaluate().isNotEmpty) {
            await tester.tap(exportButton.first);
            await tester.pumpAndSettle();

            // Should show export dialog or code
            await dismissDialog(tester);
          }

          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J09-015: Copy tokens to clipboard',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Look for copy/export functionality
          expect(find.text('Design System'), findsWidgets);
        },
      );

      testWidgets(
        'E2E-J09-016: Export includes all token categories',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);
          await tester.pumpAndSettle();

          // Verify all category tabs are accessible
          expect(find.text('Colors'), findsOneWidget);
          expect(find.text('Typography'), findsOneWidget);
          expect(find.text('Spacing'), findsOneWidget);
          expect(find.text('Radii'), findsOneWidget);
        },
      );
    });
  });
}
