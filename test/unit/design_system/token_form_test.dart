// ignore_for_file: prefer_int_literals

import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/design_system/token_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Token Form (Task 3.2)', () {
    group('Color Token Form', () {
      testWidgets('renders color form fields', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        expect(find.text('Token Name'), findsOneWidget);
        expect(find.text('Light Value'), findsOneWidget);
        expect(find.text('Dark Value'), findsOneWidget);
      });

      testWidgets('creates color token on submit', (tester) async {
        DesignToken? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (token) => result = token,
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'testColor',
        );
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );
        await tester.enterText(
          find.byKey(const Key('dark_value_field')),
          '330000FF',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(result, isNotNull);
        expect(result!.name, 'testColor');
        expect(result!.type, TokenType.color);
        expect(result!.lightValue, 0xFF0000FF);
        expect(result!.darkValue, 0x330000FF);
      });

      testWidgets('uses light value for dark if not specified', (tester) async {
        DesignToken? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (token) => result = token,
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'testColor',
        );
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(result!.darkValue, 0xFF0000FF);
      });
    });

    group('Typography Token Form', () {
      testWidgets('renders typography form fields', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.typography,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        expect(find.text('Token Name'), findsOneWidget);
        expect(find.text('Font Family'), findsOneWidget);
        expect(find.text('Font Size'), findsOneWidget);
        expect(find.text('Font Weight'), findsOneWidget);
        expect(find.text('Line Height'), findsOneWidget);
      });

      testWidgets('creates typography token on submit', (tester) async {
        DesignToken? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.typography,
                onSave: (token) => result = token,
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'headingLarge',
        );
        await tester.enterText(
          find.byKey(const Key('font_family_field')),
          'Roboto',
        );
        await tester.enterText(
          find.byKey(const Key('font_size_field')),
          '32',
        );

        // Tap on dropdown and select 700
        await tester.tap(find.byKey(const Key('font_weight_field')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('700 - Bold').last);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(result, isNotNull);
        expect(result!.name, 'headingLarge');
        expect(result!.type, TokenType.typography);
        expect(result!.typographyValue!.fontFamily, 'Roboto');
        expect(result!.typographyValue!.fontSize, 32.0);
        expect(result!.typographyValue!.fontWeight, 700);
      });

      testWidgets('shows font weight dropdown', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.typography,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        // Font weight should have a dropdown
        expect(find.byKey(const Key('font_weight_field')), findsOneWidget);
        expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      });
    });

    group('Spacing Token Form', () {
      testWidgets('renders spacing form fields', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.spacing,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        expect(find.text('Token Name'), findsOneWidget);
        expect(find.text('Value'), findsOneWidget);
      });

      testWidgets('creates spacing token on submit', (tester) async {
        DesignToken? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.spacing,
                onSave: (token) => result = token,
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'spacingMedium',
        );
        await tester.enterText(
          find.byKey(const Key('value_field')),
          '16',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(result, isNotNull);
        expect(result!.name, 'spacingMedium');
        expect(result!.type, TokenType.spacing);
        expect(result!.spacingValue, 16.0);
      });

      testWidgets('shows spacing preview', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.spacing,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('value_field')),
          '24',
        );
        await tester.pump();

        expect(find.byKey(const Key('spacing_preview')), findsOneWidget);
      });
    });

    group('Radius Token Form', () {
      testWidgets('renders radius form fields', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.radius,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        expect(find.text('Token Name'), findsOneWidget);
        expect(find.text('Value'), findsOneWidget);
      });

      testWidgets('creates radius token on submit', (tester) async {
        DesignToken? result;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.radius,
                onSave: (token) => result = token,
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'radiusSmall',
        );
        await tester.enterText(
          find.byKey(const Key('value_field')),
          '4',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(result, isNotNull);
        expect(result!.name, 'radiusSmall');
        expect(result!.type, TokenType.radius);
        expect(result!.radiusValue, 4.0);
      });

      testWidgets('shows radius preview', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.radius,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('value_field')),
          '8',
        );
        await tester.pump();

        expect(find.byKey(const Key('radius_preview')), findsOneWidget);
      });
    });

    group('Edit Mode', () {
      testWidgets('shows edit title when editing', (tester) async {
        final existingToken = DesignToken.color(
          id: 'c1',
          name: 'existingColor',
          lightValue: 0xFF3B82F6,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                existingToken: existingToken,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        expect(find.text('Edit Token'), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('pre-populates fields with existing values', (tester) async {
        final existingToken = DesignToken.color(
          id: 'c1',
          name: 'existingColor',
          lightValue: 0xFF3B82F6,
          darkValue: 0xFF60A5FA,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                existingToken: existingToken,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        final nameField = tester.widget<TextField>(
          find.byKey(const Key('token_name_field')),
        );
        expect(nameField.controller?.text, 'existingColor');

        final lightField = tester.widget<TextField>(
          find.byKey(const Key('light_value_field')),
        );
        expect(lightField.controller?.text.toUpperCase(), 'FF3B82F6');
      });

      testWidgets('preserves ID when editing', (tester) async {
        DesignToken? result;

        final existingToken = DesignToken.color(
          id: 'c1',
          name: 'existingColor',
          lightValue: 0xFF3B82F6,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                existingToken: existingToken,
                onSave: (token) => result = token,
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'renamedColor',
        );

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(result!.id, 'c1'); // ID should be preserved
        expect(result!.name, 'renamedColor');
      });
    });

    group('Validation', () {
      testWidgets('shows error for empty name', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        // Add light value to avoid that error
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(find.text('Name is required'), findsOneWidget);
      });

      testWidgets('shows error for invalid camelCase', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'Invalid Name',
        );
        await tester.enterText(
          find.byKey(const Key('light_value_field')),
          'FF0000FF',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(find.text('Name must be in camelCase'), findsOneWidget);
      });

      testWidgets('shows error when light value is empty', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'testColor',
        );
        // Don't enter light value

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(find.text('Light value is required'), findsOneWidget);
      });

      testWidgets('shows error for negative spacing', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.spacing,
                onSave: (_) {},
                onCancel: () {},
              ),
            ),
          ),
        );

        await tester.enterText(
          find.byKey(const Key('token_name_field')),
          'testSpacing',
        );
        await tester.enterText(
          find.byKey(const Key('value_field')),
          '-8',
        );

        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        expect(find.text('Value must be positive'), findsOneWidget);
      });
    });

    group('Cancel Action', () {
      testWidgets('cancel calls onCancel callback', (tester) async {
        var cancelled = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TokenForm(
                tokenType: TokenType.color,
                onSave: (_) {},
                onCancel: () => cancelled = true,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(cancelled, isTrue);
      });
    });
  });
}
