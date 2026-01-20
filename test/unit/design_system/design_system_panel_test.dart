// ignore_for_file: prefer_int_literals

import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/design_system/design_system_panel.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Design System Panel (Task 3.2)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget buildTestWidget({List<DesignToken>? initialTokens}) {
      if (initialTokens != null) {
        container.read(designTokensProvider.notifier).setTokens(initialTokens);
      }

      return UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: DesignSystemPanel(),
          ),
        ),
      );
    }

    group('Panel Structure', () {
      testWidgets('renders panel with header', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Design System'), findsOneWidget);
      });

      testWidgets('shows category tabs', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Colors'), findsOneWidget);
        expect(find.text('Typography'), findsOneWidget);
        expect(find.text('Spacing'), findsOneWidget);
        expect(find.text('Radii'), findsOneWidget);
      });

      testWidgets('switching tabs shows correct content', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
          DesignToken.typography(
            id: 't1',
            name: 'headingLarge',
            fontSize: 32.0,
          ),
          DesignToken.spacing(id: 's1', name: 'small', value: 8.0),
          DesignToken.radius(id: 'r1', name: 'radiusSmall', value: 4.0),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        // Default is Colors tab - shows color token
        expect(find.text('primaryColor'), findsOneWidget);
        expect(find.text('headingLarge'), findsNothing);

        // Switch to Typography tab
        await tester.tap(find.text('Typography'));
        await tester.pumpAndSettle();

        expect(find.text('headingLarge'), findsOneWidget);
        expect(find.text('primaryColor'), findsNothing);

        // Switch to Spacing tab
        await tester.tap(find.text('Spacing'));
        await tester.pumpAndSettle();

        expect(find.text('small'), findsOneWidget);

        // Switch to Radii tab
        await tester.tap(find.text('Radii'));
        await tester.pumpAndSettle();

        expect(find.text('radiusSmall'), findsOneWidget);
      });
    });

    group('Empty State', () {
      testWidgets('shows empty state when no tokens', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('No color tokens'), findsOneWidget);
        expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
      });

      testWidgets('shows add token button in empty state', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Add Token'), findsOneWidget);
      });
    });

    group('Token List', () {
      testWidgets('displays color tokens', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
            darkValue: 0xFF60A5FA,
          ),
          DesignToken.color(
            id: 'c2',
            name: 'secondaryColor',
            lightValue: 0xFF10B981,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        expect(find.text('primaryColor'), findsOneWidget);
        expect(find.text('secondaryColor'), findsOneWidget);
      });

      testWidgets('displays token color preview', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        // Find the color preview container
        final colorPreview = find.byKey(const Key('token_preview_c1'));
        expect(colorPreview, findsOneWidget);
      });

      testWidgets('displays typography tokens in typography tab',
          (tester) async {
        final tokens = [
          DesignToken.typography(
            id: 't1',
            name: 'headingLarge',
            fontFamily: 'Roboto',
            fontSize: 32.0,
            fontWeight: 700,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        // Switch to Typography tab
        await tester.tap(find.text('Typography'));
        await tester.pumpAndSettle();

        expect(find.text('headingLarge'), findsOneWidget);
        // Subtitle shows "fontFamily, fontSize"
        expect(find.textContaining('Roboto'), findsOneWidget);
        expect(find.textContaining('32'), findsOneWidget);
      });

      testWidgets('displays spacing tokens in spacing tab', (tester) async {
        final tokens = [
          DesignToken.spacing(
            id: 's1',
            name: 'spacingSmall',
            value: 8.0,
          ),
          DesignToken.spacing(
            id: 's2',
            name: 'spacingMedium',
            value: 16.0,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        // Switch to Spacing tab
        await tester.tap(find.text('Spacing'));
        await tester.pumpAndSettle();

        expect(find.text('spacingSmall'), findsOneWidget);
        expect(find.text('8'), findsOneWidget);
        expect(find.text('spacingMedium'), findsOneWidget);
        expect(find.text('16'), findsOneWidget);
      });

      testWidgets('displays radius tokens in radii tab', (tester) async {
        final tokens = [
          DesignToken.radius(
            id: 'r1',
            name: 'radiusSmall',
            value: 4.0,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        // Switch to Radii tab
        await tester.tap(find.text('Radii'));
        await tester.pumpAndSettle();

        expect(find.text('radiusSmall'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
      });
    });

    group('Add Token', () {
      testWidgets('tapping add shows token form', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('token_form')), findsOneWidget);
        expect(find.text('Token Name'), findsOneWidget);
      });

      testWidgets('color form shows color picker', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        // Color picker should be visible for color tokens
        expect(find.byKey(const Key('color_picker')), findsOneWidget);
      });

      testWidgets('submitting form adds token', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        // Enter token name
        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'newColor',
        );

        // Enter light value (required for color tokens)
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );

        // Submit the form
        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        // Token should be added
        final tokens = container.read(designTokensProvider);
        expect(tokens.any((t) => t.name == 'newColor'), isTrue);
      });

      testWidgets('validates camelCase name', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        // Enter invalid name
        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'Invalid Name',
        );

        // Enter light value
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );

        // Try to submit
        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        // Should show error
        expect(find.text('Name must be in camelCase'), findsOneWidget);
      });

      testWidgets('suggests valid name for invalid input', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        // Enter invalid name
        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'Primary Color',
        );

        // Wait for suggestion
        await tester.pump(const Duration(milliseconds: 500));

        // Should show suggestion
        expect(find.text('Suggestion: primaryColor'), findsOneWidget);
      });

      testWidgets('cancel closes form without adding', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'testToken',
        );

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Form should be closed
        expect(find.byKey(const Key('token_form')), findsNothing);

        // Token should not be added
        final tokens = container.read(designTokensProvider);
        expect(tokens.isEmpty, isTrue);
      });
    });

    group('Edit Token', () {
      testWidgets('tapping token opens edit form', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        await tester.tap(find.text('primaryColor'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('token_form')), findsOneWidget);
        expect(find.text('Edit Token'), findsOneWidget);
      });

      testWidgets('edit form is pre-populated with values', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        await tester.tap(find.text('primaryColor'));
        await tester.pumpAndSettle();

        // Name field should have current value
        final nameField = find.byKey(const Key('token_name_field'));
        expect(
          tester.widget<TextField>(nameField).controller?.text,
          'primaryColor',
        );
      });

      testWidgets('saving edit updates token', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        await tester.tap(find.text('primaryColor'));
        await tester.pumpAndSettle();

        // Change name
        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'brandColor',
        );

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Token should be updated
        final updatedTokens = container.read(designTokensProvider);
        expect(updatedTokens.first.name, 'brandColor');
      });
    });

    group('Delete Token', () {
      testWidgets('shows delete button on token item', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      });

      testWidgets('tapping delete removes token', (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'primaryColor',
            lightValue: 0xFF3B82F6,
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        // Token should be removed
        final updatedTokens = container.read(designTokensProvider);
        expect(updatedTokens.isEmpty, isTrue);
      });

      testWidgets('shows confirmation for delete when aliases exist',
          (tester) async {
        final tokens = [
          DesignToken.color(
            id: 'c1',
            name: 'blue500',
            lightValue: 0xFF3B82F6,
          ),
          DesignToken.alias(
            id: 'a1',
            name: 'primary',
            type: TokenType.color,
            aliasOf: 'blue500',
          ),
        ];

        await tester.pumpWidget(buildTestWidget(initialTokens: tokens));

        // Delete the base token (first delete icon)
        await tester.tap(find.byIcon(Icons.delete_outline).first);
        await tester.pumpAndSettle();

        // Should show confirmation dialog
        expect(find.text('Token has aliases'), findsOneWidget);
      });
    });

    group('Token Form Fields', () {
      testWidgets('color form has light and dark value fields', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        expect(find.text('Light Value'), findsOneWidget);
        expect(find.text('Dark Value'), findsOneWidget);
      });

      testWidgets('typography form has all font properties', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Switch to Typography tab
        await tester.tap(find.text('Typography'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        expect(find.text('Font Family'), findsOneWidget);
        expect(find.text('Font Size'), findsOneWidget);
        expect(find.text('Font Weight'), findsOneWidget);
        expect(find.text('Line Height'), findsOneWidget);
      });

      testWidgets('spacing form has value field', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Switch to Spacing tab
        await tester.tap(find.text('Spacing'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        expect(find.text('Value'), findsOneWidget);
      });

      testWidgets('radius form has value field', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Switch to Radii tab
        await tester.tap(find.text('Radii'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        expect(find.text('Value'), findsOneWidget);
      });
    });

    group('Color Picker', () {
      testWidgets('color picker updates preview', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        // Enter a hex color
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );
        await tester.pump();

        // Preview should exist
        final preview = find.byKey(const Key('color_preview'));
        expect(preview, findsOneWidget);
      });

      testWidgets('tapping color swatch opens picker', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Add Token'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('color_picker')));
        await tester.pumpAndSettle();

        // Color picker dialog should open
        expect(find.byKey(const Key('color_picker_dialog')), findsOneWidget);
      });
    });

    group('Add Token Per Category', () {
      testWidgets('each tab has its own add button', (tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Colors tab (empty state has Add Token)
        expect(find.text('Add Token'), findsOneWidget);

        // Typography tab
        await tester.tap(find.text('Typography'));
        await tester.pumpAndSettle();
        expect(find.text('Add Token'), findsOneWidget);

        // Spacing tab
        await tester.tap(find.text('Spacing'));
        await tester.pumpAndSettle();
        expect(find.text('Add Token'), findsOneWidget);

        // Radii tab
        await tester.tap(find.text('Radii'));
        await tester.pumpAndSettle();
        expect(find.text('Add Token'), findsOneWidget);
      });
    });
  });
}
