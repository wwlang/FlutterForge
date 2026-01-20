import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/generators/theme_extension_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThemeExtension Export (Task 3.7)', () {
    late ThemeExtensionGenerator generator;

    setUp(() {
      generator = ThemeExtensionGenerator();
    });

    group('Basic Generation', () {
      test('generates valid ThemeExtension class', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'primaryColor',
            lightValue: 0xFF2196F3,
            darkValue: 0xFF1976D2,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code,
            contains('class AppColors extends ThemeExtension<AppColors>'));
        expect(code, contains("import 'package:flutter/material.dart'"));
      });

      test('generates empty extension with no tokens', () {
        final code = generator.generate(
          tokens: [],
          extensionName: 'EmptyTheme',
        );

        expect(code,
            contains('class EmptyTheme extends ThemeExtension<EmptyTheme>'));
      });

      test('supports extension name customization', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF000000),
        ];

        final code1 = generator.generate(
          tokens: tokens,
          extensionName: 'CustomColors',
        );
        final code2 = generator.generate(
          tokens: tokens,
          extensionName: 'BrandTheme',
        );

        expect(code1, contains('class CustomColors'));
        expect(code2, contains('class BrandTheme'));
      });
    });

    group('Color Token Mapping', () {
      test('maps color tokens to Color? type', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'primaryColor',
            lightValue: 0xFF2196F3,
          ),
          DesignToken.color(
            id: 't2',
            name: 'backgroundColor',
            lightValue: 0xFFFFFFFF,
            darkValue: 0xFF121212,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('final Color? primaryColor'));
        expect(code, contains('final Color? backgroundColor'));
      });

      test('generates color values correctly', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'primary',
            lightValue: 0xFF2196F3,
            darkValue: 0xFF1976D2,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Colors',
        );

        expect(code, contains('Color(0xFF2196F3)'));
        expect(code, contains('Color(0xFF1976D2)'));
      });
    });

    group('Spacing Token Mapping', () {
      test('maps spacing tokens to double? type', () {
        final tokens = [
          DesignToken.spacing(id: 't1', name: 'spacingSmall', value: 8.0),
          DesignToken.spacing(id: 't2', name: 'spacingMedium', value: 16.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppSpacing',
        );

        expect(code, contains('final double? spacingSmall'));
        expect(code, contains('final double? spacingMedium'));
      });

      test('generates spacing values correctly', () {
        final tokens = [
          DesignToken.spacing(id: 't1', name: 'padding', value: 12.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Spacing',
        );

        expect(code, contains('padding: 12.0'));
      });
    });

    group('Radius Token Mapping', () {
      test('maps radius tokens to double? type', () {
        final tokens = [
          DesignToken.radius(id: 't1', name: 'radiusSmall', value: 4.0),
          DesignToken.radius(id: 't2', name: 'radiusLarge', value: 16.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppRadius',
        );

        expect(code, contains('final double? radiusSmall'));
        expect(code, contains('final double? radiusLarge'));
      });
    });

    group('Typography Token Mapping', () {
      test('maps typography tokens to TextStyle? type', () {
        final tokens = [
          DesignToken.typography(
            id: 't1',
            name: 'headline',
            fontSize: 24.0,
            fontWeight: 700,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppTypography',
        );

        expect(code, contains('final TextStyle? headline'));
      });

      test('generates TextStyle with all properties', () {
        final tokens = [
          DesignToken.typography(
            id: 't1',
            name: 'body',
            fontFamily: 'Roboto',
            fontSize: 16.0,
            fontWeight: 400,
            lineHeight: 1.5,
            letterSpacing: 0.5,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Typography',
        );

        expect(code, contains('TextStyle('));
        expect(code, contains("fontFamily: 'Roboto'"));
        expect(code, contains('fontSize: 16.0'));
        expect(code, contains('fontWeight: FontWeight.w400'));
        expect(code, contains('height: 1.5'));
        expect(code, contains('letterSpacing: 0.5'));
      });
    });

    group('Light and Dark Theme Instances', () {
      test('generates static light instance', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'surface',
            lightValue: 0xFFFFFFFF,
            darkValue: 0xFF121212,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('static const AppColors light = AppColors('));
        expect(code, contains('surface: Color(0xFFFFFFFF)'));
      });

      test('generates static dark instance', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'surface',
            lightValue: 0xFFFFFFFF,
            darkValue: 0xFF121212,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('static const AppColors dark = AppColors('));
        expect(code, contains('surface: Color(0xFF121212)'));
      });

      test('handles tokens without dark values', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'accent',
            lightValue: 0xFF4CAF50,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Colors',
        );

        // Dark should use light value as fallback
        expect(code, contains('static const Colors light'));
        expect(code, contains('static const Colors dark'));
      });
    });

    group('copyWith Method', () {
      test('generates copyWith method', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
          DesignToken.spacing(id: 't2', name: 'padding', value: 16.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppTheme',
        );

        expect(code, contains('@override'));
        expect(code, contains('AppTheme copyWith('));
        expect(code, contains('Color? primary'));
        expect(code, contains('double? padding'));
      });

      test('copyWith preserves existing values when null', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'color', lightValue: 0xFF000000),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Theme',
        );

        expect(code, contains('color: color ?? this.color'));
      });
    });

    group('lerp Method', () {
      test('generates lerp method', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('@override'));
        expect(code, contains('AppColors lerp('));
        expect(code, contains('ThemeExtension<AppColors>? other'));
        expect(code, contains('double t'));
      });

      test('lerp uses Color.lerp for colors', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Colors',
        );

        expect(code, contains('Color.lerp(primary, other.primary, t)'));
      });

      test('lerp uses lerpDouble for spacing/radius', () {
        final tokens = [
          DesignToken.spacing(id: 't1', name: 'padding', value: 16.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Spacing',
        );

        expect(code, contains('lerpDouble(padding, other.padding, t)'));
      });

      test('lerp uses TextStyle.lerp for typography', () {
        final tokens = [
          DesignToken.typography(id: 't1', name: 'body', fontSize: 16.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Typography',
        );

        expect(code, contains('TextStyle.lerp(body, other.body, t)'));
      });

      test('lerp returns this if other is null or wrong type', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'color', lightValue: 0xFF000000),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Theme',
        );

        expect(code, contains('if (other is! Theme)'));
        expect(code, contains('return this'));
      });
    });

    group('Code Formatting', () {
      test('generates formatted code with dart_style', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        // Code should be properly formatted (no consecutive closing braces without newline)
        expect(code, isNot(contains('} }')));
        // Code should not have triple blank lines
        expect(code, isNot(contains('\n\n\n\n')));
      });

      test('generated code is syntactically valid', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'primary',
            lightValue: 0xFF2196F3,
            darkValue: 0xFF1976D2,
          ),
          DesignToken.spacing(id: 't2', name: 'padding', value: 16.0),
          DesignToken.radius(id: 't3', name: 'radius', value: 8.0),
          DesignToken.typography(
            id: 't4',
            name: 'headline',
            fontSize: 24.0,
            fontWeight: 700,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppTheme',
        );

        // Check for balanced braces
        final openBraces = '{'.allMatches(code).length;
        final closeBraces = '}'.allMatches(code).length;
        expect(openBraces, equals(closeBraces));

        // Check for balanced parentheses
        final openParens = '('.allMatches(code).length;
        final closeParens = ')'.allMatches(code).length;
        expect(openParens, equals(closeParens));
      });
    });

    group('Usage Comments', () {
      test('includes usage example in comments', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('///'));
        expect(code, contains('ThemeData'));
        expect(code, contains('extensions'));
      });

      test('shows how to access extension from context', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('Theme.of(context).extension<AppColors>()'));
      });
    });

    group('Constructor', () {
      test('generates const constructor', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppColors',
        );

        expect(code, contains('const AppColors('));
      });

      test('generates constructor with named parameters', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'primary', lightValue: 0xFF2196F3),
          DesignToken.color(
              id: 't2', name: 'secondary', lightValue: 0xFF9C27B0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Colors',
        );

        expect(code, contains('this.primary'));
        expect(code, contains('this.secondary'));
      });
    });

    group('Alias Tokens', () {
      test('skips alias tokens (only generates base tokens)', () {
        final tokens = [
          DesignToken.color(id: 't1', name: 'blue', lightValue: 0xFF2196F3),
          DesignToken.alias(
            id: 't2',
            name: 'primaryColor',
            type: TokenType.color,
            aliasOf: 'blue',
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Colors',
        );

        expect(code, contains('final Color? blue'));
        // Alias should not be included as a separate field
        expect(code, isNot(contains('final Color? primaryColor')));
      });
    });

    group('Mixed Token Types', () {
      test('handles all token types together', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'primary',
            lightValue: 0xFF2196F3,
            darkValue: 0xFF1976D2,
          ),
          DesignToken.spacing(id: 't2', name: 'paddingSmall', value: 8.0),
          DesignToken.radius(id: 't3', name: 'borderRadius', value: 12.0),
          DesignToken.typography(
            id: 't4',
            name: 'bodyText',
            fontSize: 16.0,
            fontWeight: 400,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'AppTheme',
        );

        expect(code, contains('final Color? primary'));
        expect(code, contains('final double? paddingSmall'));
        expect(code, contains('final double? borderRadius'));
        expect(code, contains('final TextStyle? bodyText'));
      });
    });

    group('Edge Cases', () {
      test('handles token names with numbers', () {
        final tokens = [
          DesignToken.spacing(id: 't1', name: 'spacing8', value: 8.0),
          DesignToken.spacing(id: 't2', name: 'spacing16', value: 16.0),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Spacing',
        );

        expect(code, contains('final double? spacing8'));
        expect(code, contains('final double? spacing16'));
      });

      test('handles very long token names', () {
        final tokens = [
          DesignToken.color(
            id: 't1',
            name: 'veryLongColorTokenNameForTesting',
            lightValue: 0xFF000000,
          ),
        ];

        final code = generator.generate(
          tokens: tokens,
          extensionName: 'Colors',
        );

        expect(code, contains('veryLongColorTokenNameForTesting'));
      });
    });
  });
}
