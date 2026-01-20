// ignore_for_file: prefer_int_literals, cascade_invocations

import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Design Tokens Provider (Task 3.1)', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial State', () {
      test('starts with empty token list', () {
        final tokens = container.read(designTokensProvider);
        expect(tokens, isEmpty);
      });
    });

    group('Add Token', () {
      test('adds color token to list', () {
        final notifier = container.read(designTokensProvider.notifier);
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        notifier.addToken(token);

        final tokens = container.read(designTokensProvider);
        expect(tokens, hasLength(1));
        expect(tokens.first.name, 'primary');
      });

      test('adds multiple tokens', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'primary',
            lightValue: 0xFF0000FF,
          ),
        );
        notifier.addToken(
          DesignToken.spacing(
            id: 's1',
            name: 'spacingSmall',
            value: 8.0,
          ),
        );

        final tokens = container.read(designTokensProvider);
        expect(tokens, hasLength(2));
      });

      test('rejects duplicate token name within same type', () {
        final notifier = container.read(designTokensProvider.notifier);

        final token1 = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );
        final token2 = DesignToken.color(
          id: 'c2',
          name: 'primary',
          lightValue: 0xFF00FF00,
        );

        notifier.addToken(token1);
        final result = notifier.addToken(token2);

        expect(result, isFalse);
        expect(container.read(designTokensProvider), hasLength(1));
      });

      test('allows same name in different token types', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'primary',
            lightValue: 0xFF0000FF,
          ),
        );
        final result = notifier.addToken(
          DesignToken.spacing(
            id: 's1',
            name: 'primary',
            value: 16.0,
          ),
        );

        expect(result, isTrue);
        expect(container.read(designTokensProvider), hasLength(2));
      });
    });

    group('Update Token', () {
      test('updates existing token', () {
        final notifier = container.read(designTokensProvider.notifier);
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        notifier.addToken(token);
        notifier.updateToken(token.copyWith(lightValue: 0xFFFF0000));

        final tokens = container.read(designTokensProvider);
        expect(tokens.first.lightValue, 0xFFFF0000);
      });

      test('update non-existent token does nothing', () {
        final notifier = container.read(designTokensProvider.notifier);
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        notifier.updateToken(token);

        expect(container.read(designTokensProvider), isEmpty);
      });
    });

    group('Delete Token', () {
      test('removes token by ID', () {
        final notifier = container.read(designTokensProvider.notifier);
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        notifier.addToken(token);
        notifier.deleteToken('c1');

        expect(container.read(designTokensProvider), isEmpty);
      });

      test('delete non-existent token does nothing', () {
        final notifier = container.read(designTokensProvider.notifier);
        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'primary',
            lightValue: 0xFF0000FF,
          ),
        );

        notifier.deleteToken('non-existent');

        expect(container.read(designTokensProvider), hasLength(1));
      });
    });

    group('Get Token', () {
      test('finds token by ID', () {
        final notifier = container.read(designTokensProvider.notifier);
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        notifier.addToken(token);
        final found = notifier.getTokenById('c1');

        expect(found, equals(token));
      });

      test('finds token by name and type', () {
        final notifier = container.read(designTokensProvider.notifier);
        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );

        notifier.addToken(token);
        final found = notifier.getTokenByName('primary', TokenType.color);

        expect(found, equals(token));
      });

      test('returns null for non-existent token', () {
        final notifier = container.read(designTokensProvider.notifier);
        expect(notifier.getTokenById('non-existent'), isNull);
        expect(
          notifier.getTokenByName('non-existent', TokenType.color),
          isNull,
        );
      });
    });

    group('Filter Tokens by Type', () {
      test('filters tokens by type', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'primary',
            lightValue: 0xFF0000FF,
          ),
        );
        notifier.addToken(
          DesignToken.color(
            id: 'c2',
            name: 'secondary',
            lightValue: 0xFF00FF00,
          ),
        );
        notifier.addToken(
          DesignToken.spacing(
            id: 's1',
            name: 'small',
            value: 8.0,
          ),
        );

        final colorTokens = notifier.getTokensByType(TokenType.color);
        expect(colorTokens, hasLength(2));
        expect(colorTokens.every((t) => t.type == TokenType.color), isTrue);

        final spacingTokens = notifier.getTokensByType(TokenType.spacing);
        expect(spacingTokens, hasLength(1));
      });
    });

    group('Alias Resolution', () {
      test('resolves alias to base token', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'blue500',
            lightValue: 0xFF3B82F6,
            darkValue: 0xFF60A5FA,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a1',
            name: 'primary',
            type: TokenType.color,
            aliasOf: 'blue500',
          ),
        );

        final resolved = notifier.resolveToken('a1');

        expect(resolved, isNotNull);
        expect(resolved!.name, 'blue500');
        expect(resolved.lightValue, 0xFF3B82F6);
      });

      test('resolves non-alias to self', () {
        final notifier = container.read(designTokensProvider.notifier);

        final token = DesignToken.color(
          id: 'c1',
          name: 'primary',
          lightValue: 0xFF0000FF,
        );
        notifier.addToken(token);

        final resolved = notifier.resolveToken('c1');
        expect(resolved, equals(token));
      });

      test('detects circular alias reference', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.alias(
            id: 'a1',
            name: 'token1',
            type: TokenType.color,
            aliasOf: 'token2',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a2',
            name: 'token2',
            type: TokenType.color,
            aliasOf: 'token1',
          ),
        );

        expect(notifier.hasCircularAlias('a1'), isTrue);
        expect(notifier.hasCircularAlias('a2'), isTrue);
      });

      test('resolves deep alias chain', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'blue500',
            lightValue: 0xFF3B82F6,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a1',
            name: 'primary',
            type: TokenType.color,
            aliasOf: 'blue500',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a2',
            name: 'accent',
            type: TokenType.color,
            aliasOf: 'primary',
          ),
        );

        final resolved = notifier.resolveToken('a2');
        expect(resolved!.name, 'blue500');
      });

      test('warns on deep alias chain', () {
        final notifier = container.read(designTokensProvider.notifier);

        // Create chain: level4 -> level3 -> level2 -> level1 -> base
        notifier.addToken(
          DesignToken.color(
            id: 'base',
            name: 'base',
            lightValue: 0xFF0000FF,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'l1',
            name: 'level1',
            type: TokenType.color,
            aliasOf: 'base',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'l2',
            name: 'level2',
            type: TokenType.color,
            aliasOf: 'level1',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'l3',
            name: 'level3',
            type: TokenType.color,
            aliasOf: 'level2',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'l4',
            name: 'level4',
            type: TokenType.color,
            aliasOf: 'level3',
          ),
        );

        // Chain depth of 4 should trigger warning
        expect(notifier.getAliasChainDepth('l4'), 4);
        expect(notifier.isDeepAliasChain('l4'), isTrue);
        expect(notifier.isDeepAliasChain('l2'), isFalse);
      });
    });

    group('Set All Tokens', () {
      test('replaces all tokens', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'old',
            lightValue: 0xFF0000FF,
          ),
        );

        final newTokens = [
          DesignToken.color(
            id: 'c2',
            name: 'new1',
            lightValue: 0xFF00FF00,
          ),
          DesignToken.spacing(
            id: 's1',
            name: 'new2',
            value: 16.0,
          ),
        ];

        notifier.setTokens(newTokens);

        final tokens = container.read(designTokensProvider);
        expect(tokens, hasLength(2));
        expect(tokens.any((t) => t.name == 'old'), isFalse);
        expect(tokens.any((t) => t.name == 'new1'), isTrue);
        expect(tokens.any((t) => t.name == 'new2'), isTrue);
      });
    });

    group('Clear All Tokens', () {
      test('removes all tokens', () {
        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'c1',
            name: 'primary',
            lightValue: 0xFF0000FF,
          ),
        );
        notifier.addToken(
          DesignToken.spacing(
            id: 's1',
            name: 'small',
            value: 8.0,
          ),
        );

        notifier.clearAll();

        expect(container.read(designTokensProvider), isEmpty);
      });
    });
  });
}
