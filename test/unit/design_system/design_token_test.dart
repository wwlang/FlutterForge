// ignore_for_file: prefer_int_literals, avoid_redundant_argument_values

import 'dart:convert';

import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Design Token Model (Task 3.1)', () {
    group('TokenType enum', () {
      test('has required types: color, typography, spacing, radius', () {
        expect(TokenType.values, contains(TokenType.color));
        expect(TokenType.values, contains(TokenType.typography));
        expect(TokenType.values, contains(TokenType.spacing));
        expect(TokenType.values, contains(TokenType.radius));
      });
    });

    group('Color Token', () {
      test('creates color token with light and dark values', () {
        final token = DesignToken.color(
          id: 'token-1',
          name: 'primaryBrand',
          lightValue: 0xFF3B82F6,
          darkValue: 0xFF60A5FA,
        );

        expect(token.id, 'token-1');
        expect(token.name, 'primaryBrand');
        expect(token.type, TokenType.color);
        expect(token.lightValue, 0xFF3B82F6);
        expect(token.darkValue, 0xFF60A5FA);
      });

      test('dark value defaults to light value if not provided', () {
        final token = DesignToken.color(
          id: 'token-1',
          name: 'surface',
          lightValue: 0xFFFFFFFF,
        );

        expect(token.darkValue, 0xFFFFFFFF);
      });
    });

    group('Typography Token', () {
      test('creates typography token with all properties', () {
        final token = DesignToken.typography(
          id: 'token-2',
          name: 'headingLarge',
          fontFamily: 'Roboto',
          fontSize: 32.0,
          fontWeight: 700,
          lineHeight: 1.2,
        );

        expect(token.id, 'token-2');
        expect(token.name, 'headingLarge');
        expect(token.type, TokenType.typography);

        final value = token.typographyValue;
        expect(value, isNotNull);
        expect(value!.fontFamily, 'Roboto');
        expect(value.fontSize, 32.0);
        expect(value.fontWeight, 700);
        expect(value.lineHeight, 1.2);
      });

      test('typography token has default values', () {
        final token = DesignToken.typography(
          id: 'token-2',
          name: 'bodyText',
        );

        final value = token.typographyValue;
        expect(value, isNotNull);
        expect(value!.fontFamily, isNull);
        expect(value.fontSize, 14.0);
        expect(value.fontWeight, 400);
        expect(value.lineHeight, 1.5);
      });
    });

    group('Spacing Token', () {
      test('creates spacing token with numeric value', () {
        final token = DesignToken.spacing(
          id: 'token-3',
          name: 'spacingMedium',
          value: 16.0,
        );

        expect(token.id, 'token-3');
        expect(token.name, 'spacingMedium');
        expect(token.type, TokenType.spacing);
        expect(token.spacingValue, 16.0);
      });
    });

    group('Radius Token', () {
      test('creates radius token with numeric value', () {
        final token = DesignToken.radius(
          id: 'token-4',
          name: 'radiusSmall',
          value: 4.0,
        );

        expect(token.id, 'token-4');
        expect(token.name, 'radiusSmall');
        expect(token.type, TokenType.radius);
        expect(token.radiusValue, 4.0);
      });
    });

    group('Token Name Validation', () {
      test('validates camelCase names', () {
        expect(DesignToken.isValidName('primaryColor'), isTrue);
        expect(DesignToken.isValidName('headingLarge'), isTrue);
        expect(DesignToken.isValidName('spacing16'), isTrue);
        expect(DesignToken.isValidName('a'), isTrue);
      });

      test('rejects invalid names', () {
        expect(DesignToken.isValidName(''), isFalse);
        expect(DesignToken.isValidName('Primary Color'), isFalse);
        expect(DesignToken.isValidName('primary-color'), isFalse);
        expect(DesignToken.isValidName('123primary'), isFalse);
        expect(DesignToken.isValidName('primary_color'), isFalse);
      });

      test('suggests valid name from invalid input', () {
        expect(DesignToken.suggestValidName('Primary Color'), 'primaryColor');
        expect(DesignToken.suggestValidName('primary-color'), 'primaryColor');
        expect(DesignToken.suggestValidName('123primary'), 'primary');
        expect(DesignToken.suggestValidName('HEADING_LARGE'), 'headingLarge');
      });
    });

    group('Alias Token', () {
      test('creates alias token referencing base token', () {
        final token = DesignToken.alias(
          id: 'token-5',
          name: 'primary',
          type: TokenType.color,
          aliasOf: 'blue500',
        );

        expect(token.id, 'token-5');
        expect(token.name, 'primary');
        expect(token.type, TokenType.color);
        expect(token.isAlias, isTrue);
        expect(token.aliasOf, 'blue500');
      });

      test('non-alias tokens have isAlias false', () {
        final token = DesignToken.color(
          id: 'token-1',
          name: 'blue500',
          lightValue: 0xFF3B82F6,
        );

        expect(token.isAlias, isFalse);
        expect(token.aliasOf, isNull);
      });
    });

    group('JSON Serialization', () {
      test('serializes color token to JSON', () {
        final token = DesignToken.color(
          id: 'token-1',
          name: 'primaryBrand',
          lightValue: 0xFF3B82F6,
          darkValue: 0xFF60A5FA,
        );

        final json = token.toJson();
        expect(json['id'], 'token-1');
        expect(json['name'], 'primaryBrand');
        expect(json['type'], 'color');
        expect(json['lightValue'], 0xFF3B82F6);
        expect(json['darkValue'], 0xFF60A5FA);
      });

      test('deserializes color token from JSON', () {
        final json = {
          'id': 'token-1',
          'name': 'primaryBrand',
          'type': 'color',
          'lightValue': 0xFF3B82F6,
          'darkValue': 0xFF60A5FA,
        };

        final token = DesignToken.fromJson(json);
        expect(token.id, 'token-1');
        expect(token.name, 'primaryBrand');
        expect(token.type, TokenType.color);
        expect(token.lightValue, 0xFF3B82F6);
        expect(token.darkValue, 0xFF60A5FA);
      });

      test('serializes typography token to JSON and back', () {
        final token = DesignToken.typography(
          id: 'token-2',
          name: 'headingLarge',
          fontFamily: 'Roboto',
          fontSize: 32.0,
          fontWeight: 700,
          lineHeight: 1.2,
        );

        // Serialize to JSON string and back (simulating file storage)
        final jsonString = jsonEncode(token.toJson());
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        final restored = DesignToken.fromJson(jsonMap);

        expect(restored.id, 'token-2');
        expect(restored.name, 'headingLarge');
        expect(restored.type, TokenType.typography);
        expect(restored.typographyValue!.fontFamily, 'Roboto');
        expect(restored.typographyValue!.fontSize, 32.0);
      });

      test('round-trip serialization preserves all token types', () {
        final colorToken = DesignToken.color(
          id: 'c1',
          name: 'surface',
          lightValue: 0xFFFFFFFF,
          darkValue: 0xFF121212,
        );
        final spacingToken = DesignToken.spacing(
          id: 's1',
          name: 'spacingLarge',
          value: 24.0,
        );
        final radiusToken = DesignToken.radius(
          id: 'r1',
          name: 'radiusMedium',
          value: 8.0,
        );

        // Round trip via JSON string (simulates file persistence)
        final colorRestored = DesignToken.fromJson(
          jsonDecode(jsonEncode(colorToken.toJson())) as Map<String, dynamic>,
        );
        final spacingRestored = DesignToken.fromJson(
          jsonDecode(jsonEncode(spacingToken.toJson())) as Map<String, dynamic>,
        );
        final radiusRestored = DesignToken.fromJson(
          jsonDecode(jsonEncode(radiusToken.toJson())) as Map<String, dynamic>,
        );

        expect(colorRestored, equals(colorToken));
        expect(spacingRestored, equals(spacingToken));
        expect(radiusRestored, equals(radiusToken));
      });

      test('round-trip serialization preserves typography token', () {
        final typographyToken = DesignToken.typography(
          id: 't1',
          name: 'headingLarge',
          fontFamily: 'Roboto',
          fontSize: 32.0,
          fontWeight: 700,
          lineHeight: 1.2,
        );

        // Round trip via JSON string (simulates file persistence)
        final jsonString = jsonEncode(typographyToken.toJson());
        final restored = DesignToken.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );

        expect(restored.id, typographyToken.id);
        expect(restored.name, typographyToken.name);
        expect(restored.type, typographyToken.type);
        expect(restored.typographyValue, typographyToken.typographyValue);
      });
    });

    group('Type-Safe Value Access', () {
      test('color token provides type-safe color values', () {
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        expect(token.lightValue, isA<int>());
        expect(token.darkValue, isA<int>());
      });

      test('typography token provides type-safe typography value', () {
        final token = DesignToken.typography(
          id: 't1',
          name: 'body',
          fontSize: 14.0,
        );

        expect(token.typographyValue, isA<TypographyValue>());
        expect(token.typographyValue!.fontSize, 14.0);
      });

      test('spacing token provides type-safe numeric value', () {
        final token = DesignToken.spacing(
          id: 's1',
          name: 'small',
          value: 8.0,
        );

        expect(token.spacingValue, isA<double>());
        expect(token.spacingValue, 8.0);
      });

      test('radius token provides type-safe numeric value', () {
        final token = DesignToken.radius(
          id: 'r1',
          name: 'small',
          value: 4.0,
        );

        expect(token.radiusValue, isA<double>());
        expect(token.radiusValue, 4.0);
      });

      test('wrong type accessor returns null', () {
        final colorToken = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        expect(colorToken.typographyValue, isNull);
        expect(colorToken.spacingValue, isNull);
        expect(colorToken.radiusValue, isNull);
      });
    });

    group('Equality and Hashing', () {
      test('tokens with same values are equal', () {
        final token1 = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );
        final token2 = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        expect(token1, equals(token2));
        expect(token1.hashCode, equals(token2.hashCode));
      });

      test('tokens with different values are not equal', () {
        final token1 = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );
        final token2 = DesignToken.color(
          id: 'c2',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        expect(token1, isNot(equals(token2)));
      });
    });

    group('CopyWith', () {
      test('color token copyWith creates new instance', () {
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
          darkValue: 0xFF3333FF,
        );

        final updated = token.copyWith(name: 'secondary');
        expect(updated.name, 'secondary');
        expect(updated.id, 'c1');
        expect(updated.lightValue, 0xFF0000FF);
      });

      test('updates dark value only', () {
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
          darkValue: 0xFF3333FF,
        );

        final updated = token.copyWith(darkValue: 0xFF6666FF);
        expect(updated.lightValue, 0xFF0000FF);
        expect(updated.darkValue, 0xFF6666FF);
      });
    });
  });
}
