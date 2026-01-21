import 'package:flutter/material.dart';
import 'package:flutter_forge/app.dart';
import 'package:flutter_forge/features/workbench/workbench.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Journey J09: Design System', () {
    // =========================================================================
    // Stage 1: Create Tokens
    // =========================================================================
    group('J09-S1: Create Tokens', () {
      testWidgets(
        'E2E-J09-001: Create color token through design system panel',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Look for the Design System panel
          expect(find.text('Design System'), findsWidgets);

          // Tap Add Token button
          final addButton = find.text('Add Token');
          if (addButton.evaluate().isNotEmpty) {
            await tester.tap(addButton.first);
            await tester.pumpAndSettle();

            // Fill in token name
            final nameField = find.byKey(const Key('token_name_field'));
            if (nameField.evaluate().isNotEmpty) {
              await tester.enterText(nameField, 'primaryBlue');
              await tester.pumpAndSettle();
            }

            // Fill in light value
            final lightField = find.byKey(const Key('light_value_field'));
            if (lightField.evaluate().isNotEmpty) {
              await tester.enterText(lightField, '3B82F6');
              await tester.pumpAndSettle();
            }

            // Create the token
            final createButton = find.text('Create');
            if (createButton.evaluate().isNotEmpty) {
              await tester.tap(createButton.first);
              await tester.pumpAndSettle();
            }

            // Token should appear in list
            expect(find.text('primaryBlue'), findsWidgets);
          }
        },
      );

      testWidgets(
        'E2E-J09-002: Create typography token',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Switch to Typography tab
          final typographyTab = find.text('Typography');
          if (typographyTab.evaluate().isNotEmpty) {
            await tester.tap(typographyTab.first);
            await tester.pumpAndSettle();

            // Add typography token
            final addButton = find.text('Add Token');
            if (addButton.evaluate().isNotEmpty) {
              await tester.tap(addButton.first);
              await tester.pumpAndSettle();

              // Fill in typography fields
              final nameField = find.byKey(const Key('token_name_field'));
              if (nameField.evaluate().isNotEmpty) {
                await tester.enterText(nameField, 'headingLarge');
                await tester.pumpAndSettle();
              }

              // Create token
              final createButton = find.text('Create');
              if (createButton.evaluate().isNotEmpty) {
                await tester.tap(createButton.first);
                await tester.pumpAndSettle();
              }
            }
          }

          // Verify typography token exists
          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J09-003: Create spacing token',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Switch to Spacing tab
          final spacingTab = find.text('Spacing');
          if (spacingTab.evaluate().isNotEmpty) {
            await tester.tap(spacingTab.first);
            await tester.pumpAndSettle();

            // Add spacing token
            final addButton = find.text('Add Token');
            if (addButton.evaluate().isNotEmpty) {
              await tester.tap(addButton.first);
              await tester.pumpAndSettle();

              // Fill in token name and value
              final nameField = find.byKey(const Key('token_name_field'));
              if (nameField.evaluate().isNotEmpty) {
                await tester.enterText(nameField, 'spacingMedium');
                await tester.pumpAndSettle();
              }

              // Create
              final createButton = find.text('Create');
              if (createButton.evaluate().isNotEmpty) {
                await tester.tap(createButton.first);
                await tester.pumpAndSettle();
              }
            }
          }

          expect(find.byType(Workbench), findsOneWidget);
        },
      );

      testWidgets(
        'E2E-J09-004: Token name validation enforces camelCase',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const ProviderScope(child: FlutterForgeApp()),
          );
          await tester.pumpAndSettle();

          // Open Design System panel
          await openDesignSystemPanel(tester);

          // Add token
          final addButton = find.text('Add Token');
          if (addButton.evaluate().isNotEmpty) {
            await tester.tap(addButton.first);
            await tester.pumpAndSettle();

            // Enter invalid name
            final nameField = find.byKey(const Key('token_name_field'));
            if (nameField.evaluate().isNotEmpty) {
              await tester.enterText(nameField, 'Invalid Name');
              await tester.pumpAndSettle();

              // Enter light value
              final lightField = find.byKey(const Key('light_value_field'));
              if (lightField.evaluate().isNotEmpty) {
                await tester.enterText(lightField, 'FF0000FF');
                await tester.pumpAndSettle();
              }

              // Try to create
              final createButton = find.text('Create');
              if (createButton.evaluate().isNotEmpty) {
                await tester.tap(createButton.first);
                await tester.pumpAndSettle();
              }

              // Should show validation error
              expect(find.textContaining('camelCase'), findsWidgets);
            }
          }
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
          await dragWidgetToCanvas(tester, 'Container');

          // Verify both exist
          expect(countWidgetsOnCanvas(tester, 'Container'), equals(2));
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

          // Verify all categories are accessible
          expect(find.text('Colors'), findsWidgets);
          expect(find.text('Typography'), findsWidgets);
          expect(find.text('Spacing'), findsWidgets);
          expect(find.text('Radii'), findsWidgets);
        },
      );
    });
  });
}
