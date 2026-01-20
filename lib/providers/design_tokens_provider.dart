import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maximum alias chain depth before warning.
const int _maxAliasChainDepth = 3;

/// Provides design tokens for the current project.
final designTokensProvider =
    StateNotifierProvider<DesignTokensNotifier, List<DesignToken>>(
  (ref) => DesignTokensNotifier(),
);

/// State notifier for managing design tokens.
class DesignTokensNotifier extends StateNotifier<List<DesignToken>> {
  DesignTokensNotifier() : super([]);

  /// Adds a token to the list.
  ///
  /// Returns false if a token with the same name and type already exists.
  bool addToken(DesignToken token) {
    // Check for duplicate name within same type
    final exists = state.any(
      (t) => t.name == token.name && t.type == token.type,
    );

    if (exists) return false;

    state = [...state, token];
    return true;
  }

  /// Updates an existing token.
  ///
  /// Does nothing if the token doesn't exist.
  void updateToken(DesignToken token) {
    final index = state.indexWhere((t) => t.id == token.id);
    if (index == -1) return;

    state = [
      ...state.sublist(0, index),
      token,
      ...state.sublist(index + 1),
    ];
  }

  /// Deletes a token by ID.
  void deleteToken(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  /// Gets a token by ID.
  DesignToken? getTokenById(String id) {
    try {
      return state.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gets a token by name and type.
  DesignToken? getTokenByName(String name, TokenType type) {
    try {
      return state.firstWhere((t) => t.name == name && t.type == type);
    } catch (_) {
      return null;
    }
  }

  /// Gets all tokens of a specific type.
  List<DesignToken> getTokensByType(TokenType type) {
    return state.where((t) => t.type == type).toList();
  }

  /// Resolves a token, following alias references to the base token.
  ///
  /// Returns null if the token doesn't exist or has a circular reference.
  DesignToken? resolveToken(String id, {Set<String>? visited}) {
    final token = getTokenById(id);
    if (token == null) return null;

    // Not an alias, return self
    if (!token.isAlias) return token;

    // Check for circular reference
    visited ??= {};
    if (visited.contains(id)) return null;
    visited.add(id);

    // Find the referenced token by name
    final referenced = getTokenByName(token.aliasOf!, token.type);
    if (referenced == null) return null;

    // Recursively resolve
    return resolveToken(referenced.id, visited: visited);
  }

  /// Checks if a token has a circular alias reference.
  bool hasCircularAlias(String id) {
    final token = getTokenById(id);
    if (token == null || !token.isAlias) return false;

    final visited = <String>{};
    var current = token;

    while (current.isAlias) {
      if (visited.contains(current.id)) return true;
      visited.add(current.id);

      final referenced = getTokenByName(current.aliasOf!, current.type);
      if (referenced == null) return false;
      current = referenced;
    }

    return false;
  }

  /// Gets the depth of an alias chain.
  int getAliasChainDepth(String id) {
    final token = getTokenById(id);
    if (token == null || !token.isAlias) return 0;

    var depth = 0;
    final visited = <String>{};
    var current = token;

    while (current.isAlias) {
      if (visited.contains(current.id)) break; // Circular reference
      visited.add(current.id);
      depth++;

      final referenced = getTokenByName(current.aliasOf!, current.type);
      if (referenced == null) break;
      current = referenced;
    }

    return depth;
  }

  /// Checks if a token has a deep alias chain (>3 levels).
  bool isDeepAliasChain(String id) {
    return getAliasChainDepth(id) > _maxAliasChainDepth;
  }

  /// Replaces all tokens with a new list.
  void setTokens(List<DesignToken> tokens) {
    state = List.unmodifiable(tokens);
  }

  /// Removes all tokens.
  void clearAll() {
    state = [];
  }
}
