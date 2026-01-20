import 'package:flutter/foundation.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';

/// Represents a binding from a widget property to a design token.
///
/// Token bindings are serialized as `{"\$token": "tokenName"}` in properties.
@immutable
class TokenBinding {
  /// Creates a token binding.
  const TokenBinding({required this.tokenName});

  /// The name of the bound token.
  final String tokenName;

  /// Whether this binding is active (always true for TokenBinding instances).
  bool get isBound => true;

  /// Serializes the binding to JSON format.
  Map<String, dynamic> toJson() => {r'$token': tokenName};

  /// Attempts to parse a JSON value as a token binding.
  ///
  /// Returns null if the value is not a token binding.
  static TokenBinding? fromJson(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    if (!value.containsKey(r'$token')) return null;
    final tokenName = value[r'$token'];
    if (tokenName is! String) return null;
    return TokenBinding(tokenName: tokenName);
  }

  /// Checks if a property value is a token binding.
  static bool isTokenBound(dynamic value) {
    if (value == null) return false;
    if (value is! Map<String, dynamic>) return false;
    return value.containsKey(r'$token');
  }

  /// Extracts the token name from a bound value.
  ///
  /// Returns null if the value is not a token binding.
  static String? getTokenName(dynamic value) {
    if (value is! Map<String, dynamic>) return null;
    if (!value.containsKey(r'$token')) return null;
    final tokenName = value[r'$token'];
    return tokenName is String ? tokenName : null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TokenBinding &&
          runtimeType == other.runtimeType &&
          tokenName == other.tokenName;

  @override
  int get hashCode => tokenName.hashCode;
}

/// Resolves a property value, handling token bindings.
///
/// If [value] is a token binding, resolves it using [notifier].
/// Otherwise, returns [value] as-is.
dynamic resolvePropertyValue(
  dynamic value,
  TokenType tokenType,
  DesignTokensNotifier notifier, {
  required bool isDarkMode,
}) {
  // Check if it's a token binding
  final tokenName = TokenBinding.getTokenName(value);
  if (tokenName == null) return value;

  // Find the token by name
  final token = notifier.getTokenByName(tokenName, tokenType);
  if (token == null) return null;

  // Resolve if it's an alias
  final resolvedToken = token.isAlias ? notifier.resolveToken(token.id) : token;
  if (resolvedToken == null) return null;

  // Return the appropriate value based on token type and theme mode
  switch (tokenType) {
    case TokenType.color:
      return isDarkMode
          ? resolvedToken.darkValue as int?
          : resolvedToken.lightValue as int?;
    case TokenType.spacing:
      return resolvedToken.spacingValue;
    case TokenType.radius:
      return resolvedToken.radiusValue;
    case TokenType.typography:
      return resolvedToken.typographyValue;
  }
}

/// Returns the resolved color value for a token as an integer.
int? resolveColorTokenValue(
  String tokenName,
  DesignTokensNotifier notifier, {
  required bool isDarkMode,
}) {
  final value = resolvePropertyValue(
    {r'$token': tokenName},
    TokenType.color,
    notifier,
    isDarkMode: isDarkMode,
  );
  return value is int ? value : null;
}

/// Returns the resolved double value for a token.
double? resolveDoubleTokenValue(
  String tokenName,
  TokenType tokenType,
  DesignTokensNotifier notifier,
) {
  final value = resolvePropertyValue(
    {r'$token': tokenName},
    tokenType,
    notifier,
    isDarkMode: false,
  );
  return value is double ? value : null;
}
