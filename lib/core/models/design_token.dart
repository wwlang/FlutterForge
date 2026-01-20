import 'package:freezed_annotation/freezed_annotation.dart';

part 'design_token.freezed.dart';
part 'design_token.g.dart';

/// Categories of design tokens.
@JsonEnum()
enum TokenType {
  /// Color tokens (e.g., primary, secondary, surface).
  color,

  /// Typography tokens (e.g., headline, body, caption).
  typography,

  /// Spacing tokens (e.g., small, medium, large).
  spacing,

  /// Border radius tokens.
  radius,
}

/// Typography token value containing font properties.
@freezed
class TypographyValue with _$TypographyValue {
  const factory TypographyValue({
    /// Font family name.
    String? fontFamily,

    /// Font size in logical pixels.
    @Default(14.0) double fontSize,

    /// Font weight (100-900).
    @Default(400) int fontWeight,

    /// Line height multiplier.
    @Default(1.5) double lineHeight,

    /// Letter spacing in logical pixels.
    @Default(0.0) double letterSpacing,
  }) = _TypographyValue;

  factory TypographyValue.fromJson(Map<String, dynamic> json) =>
      _$TypographyValueFromJson(json);
}

/// Design token for theming system.
///
/// Supports light/dark mode values for color tokens and
/// structured values for typography, spacing, and radius tokens.
@freezed
class DesignToken with _$DesignToken {
  /// Creates a new design token.
  const factory DesignToken({
    /// Unique token identifier (UUID).
    required String id,

    /// Token name (e.g., 'primaryColor', 'bodyText').
    required String name,

    /// Token type category.
    required TokenType type,

    /// Value for light theme mode (int for color, double for spacing/radius).
    dynamic lightValue,

    /// Value for dark theme mode (int for color).
    dynamic darkValue,

    /// High contrast value for light theme mode.
    dynamic highContrastLightValue,

    /// High contrast value for dark theme mode.
    dynamic highContrastDarkValue,

    /// Typography value for typography tokens.
    TypographyValue? typography,

    /// Reference to another token name if this is an alias.
    String? aliasOf,
  }) = _DesignToken;

  const DesignToken._();

  /// Creates a color token with light and dark values.
  factory DesignToken.color({
    required String id,
    required String name,
    required int lightValue,
    int? darkValue,
    int? highContrastLightValue,
    int? highContrastDarkValue,
  }) {
    return DesignToken(
      id: id,
      name: name,
      type: TokenType.color,
      lightValue: lightValue,
      darkValue: darkValue ?? lightValue,
      highContrastLightValue: highContrastLightValue,
      highContrastDarkValue: highContrastDarkValue,
    );
  }

  /// Creates a typography token with font properties.
  factory DesignToken.typography({
    required String id,
    required String name,
    String? fontFamily,
    double fontSize = 14.0,
    int fontWeight = 400,
    double lineHeight = 1.5,
    double letterSpacing = 0.0,
  }) {
    return DesignToken(
      id: id,
      name: name,
      type: TokenType.typography,
      typography: TypographyValue(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        lineHeight: lineHeight,
        letterSpacing: letterSpacing,
      ),
    );
  }

  /// Creates a spacing token with a numeric value.
  factory DesignToken.spacing({
    required String id,
    required String name,
    required double value,
  }) {
    return DesignToken(
      id: id,
      name: name,
      type: TokenType.spacing,
      lightValue: value,
      darkValue: value,
    );
  }

  /// Creates a radius token with a numeric value.
  factory DesignToken.radius({
    required String id,
    required String name,
    required double value,
  }) {
    return DesignToken(
      id: id,
      name: name,
      type: TokenType.radius,
      lightValue: value,
      darkValue: value,
    );
  }

  /// Creates an alias token that references another token.
  factory DesignToken.alias({
    required String id,
    required String name,
    required TokenType type,
    required String aliasOf,
  }) {
    return DesignToken(
      id: id,
      name: name,
      type: type,
      aliasOf: aliasOf,
    );
  }

  factory DesignToken.fromJson(Map<String, dynamic> json) =>
      _$DesignTokenFromJson(json);

  /// Whether this token is an alias to another token.
  bool get isAlias => aliasOf != null;

  /// Gets the typography value if this is a typography token.
  TypographyValue? get typographyValue =>
      type == TokenType.typography ? typography : null;

  /// Gets the spacing value if this is a spacing token.
  double? get spacingValue =>
      type == TokenType.spacing ? (lightValue as num?)?.toDouble() : null;

  /// Gets the radius value if this is a radius token.
  double? get radiusValue =>
      type == TokenType.radius ? (lightValue as num?)?.toDouble() : null;

  static final _startsWithLowercaseRegex = RegExp('^[a-z]');
  static final _camelCaseRegex = RegExp(r'^[a-z][a-zA-Z0-9]*$');
  static final _leadingDigitsRegex = RegExp('^[0-9]+');
  static final _nonAlphanumericRegex = RegExp('[^a-zA-Z0-9]+');
  static final _startsWithUppercaseRegex = RegExp('^[A-Z]');

  /// Validates a token name.
  ///
  /// Valid names must:
  /// - Start with a lowercase letter
  /// - Contain only alphanumeric characters
  /// - Be in camelCase format
  static bool isValidName(String name) {
    if (name.isEmpty) return false;

    // Must start with lowercase letter
    if (!_startsWithLowercaseRegex.hasMatch(name)) return false;

    // Must be alphanumeric only (camelCase)
    if (!_camelCaseRegex.hasMatch(name)) return false;

    return true;
  }

  /// Suggests a valid camelCase name from an invalid input.
  static String suggestValidName(String input) {
    // Remove leading numbers
    var result = input.replaceFirst(_leadingDigitsRegex, '');

    // Split on non-alphanumeric characters
    final parts =
        result.split(_nonAlphanumericRegex).where((p) => p.isNotEmpty);

    if (parts.isEmpty) return 'token';

    // Convert to camelCase
    final buffer = StringBuffer();
    var first = true;
    for (final part in parts) {
      if (first) {
        buffer.write(part.toLowerCase());
        first = false;
      } else {
        buffer.write(part[0].toUpperCase());
        if (part.length > 1) {
          buffer.write(part.substring(1).toLowerCase());
        }
      }
    }

    result = buffer.toString();

    // Ensure starts with lowercase letter
    if (result.isNotEmpty && _startsWithUppercaseRegex.hasMatch(result)) {
      result = result[0].toLowerCase() + result.substring(1);
    }

    return result.isEmpty ? 'token' : result;
  }
}
