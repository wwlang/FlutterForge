import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/features/design_system/design_system_panel.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Semantic Token Aliasing (Task 3.3)', () {
    group('Alias Token Creation', () {
      test('alias token references base token by name', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create base token
        final baseToken = DesignToken.color(
          id: 'base-1',
          name: 'brandPrimary',
          lightValue: 0xFF0000FF,
          darkValue: 0xFF0000CC,
        );
        notifier.addToken(baseToken);

        // Create alias token
        final aliasToken = DesignToken.alias(
          id: 'alias-1',
          name: 'buttonBackground',
          type: TokenType.color,
          aliasOf: 'brandPrimary',
        );
        notifier.addToken(aliasToken);

        final tokens = container.read(designTokensProvider);
        expect(tokens.length, 2);

        final addedAlias =
            notifier.getTokenByName('buttonBackground', TokenType.color);
        expect(addedAlias?.isAlias, true);
        expect(addedAlias?.aliasOf, 'brandPrimary');
      });

      test('alias type must match base token type', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create color base token
        final baseToken = DesignToken.color(
          id: 'base-1',
          name: 'brandPrimary',
          lightValue: 0xFF0000FF,
        );
        notifier.addToken(baseToken);

        // Alias with different type - the system should handle this
        // by only allowing same-type aliases in UI
        final aliasToken = DesignToken.alias(
          id: 'alias-1',
          name: 'aliasSpacing',
          type: TokenType.spacing, // Different type
          aliasOf: 'brandPrimary',
        );
        notifier.addToken(aliasToken);

        // Resolution should fail because base is color, alias is spacing
        final resolved = notifier.resolveToken('alias-1');
        expect(resolved, isNull); // Cannot resolve cross-type alias
      });
    });

    group('Alias Resolution', () {
      test('resolves alias to base token value', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create base token
        final baseToken = DesignToken.color(
          id: 'base-1',
          name: 'brandPrimary',
          lightValue: 0xFF0000FF,
          darkValue: 0xFF0000CC,
        );
        notifier.addToken(baseToken);

        // Create alias token
        final aliasToken = DesignToken.alias(
          id: 'alias-1',
          name: 'buttonBackground',
          type: TokenType.color,
          aliasOf: 'brandPrimary',
        );
        notifier.addToken(aliasToken);

        // Resolve alias
        final resolved = notifier.resolveToken('alias-1');
        expect(resolved, isNotNull);
        expect(resolved!.id, 'base-1');
        expect(resolved.lightValue, 0xFF0000FF);
        expect(resolved.darkValue, 0xFF0000CC);
      });

      test('changes to base propagate to aliases instantly', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create and add base token
        final baseToken = DesignToken.color(
          id: 'base-1',
          name: 'brandPrimary',
          lightValue: 0xFF0000FF,
        );
        notifier.addToken(baseToken);

        // Create alias
        final aliasToken = DesignToken.alias(
          id: 'alias-1',
          name: 'buttonBackground',
          type: TokenType.color,
          aliasOf: 'brandPrimary',
        );
        notifier.addToken(aliasToken);

        // Verify initial resolution
        var resolved = notifier.resolveToken('alias-1');
        expect(resolved?.lightValue, 0xFF0000FF);

        // Update base token
        final updatedBase = DesignToken.color(
          id: 'base-1',
          name: 'brandPrimary',
          lightValue: 0xFFFF0000, // Changed to red
        );
        notifier.updateToken(updatedBase);

        // Resolution should reflect new value
        resolved = notifier.resolveToken('alias-1');
        expect(resolved?.lightValue, 0xFFFF0000);
      });

      test('resolves deep alias chain (A -> B -> C)', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create chain: C is base, B aliases C, A aliases B
        notifier.addToken(
          DesignToken.spacing(
            id: 'c',
            name: 'basePadding',
            value: 16,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'componentPadding',
            type: TokenType.spacing,
            aliasOf: 'basePadding',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'buttonPadding',
            type: TokenType.spacing,
            aliasOf: 'componentPadding',
          ),
        );

        // Resolution should traverse to base
        final resolved = notifier.resolveToken('a');
        expect(resolved?.id, 'c');
        expect(resolved?.spacingValue, 16.0);
      });
    });

    group('Circular Reference Detection', () {
      test('detects direct circular reference (A -> A)', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Self-referencing alias (shouldn't happen but test detection)
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'selfRef',
            type: TokenType.color,
            aliasOf: 'selfRef',
          ),
        );

        expect(notifier.hasCircularAlias('a'), true);
        expect(notifier.resolveToken('a'), isNull);
      });

      test('detects indirect circular reference (A -> B -> A)', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create circular: A -> B -> A
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'tokenA',
            type: TokenType.color,
            aliasOf: 'tokenB',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'tokenB',
            type: TokenType.color,
            aliasOf: 'tokenA',
          ),
        );

        expect(notifier.hasCircularAlias('a'), true);
        expect(notifier.hasCircularAlias('b'), true);
        expect(notifier.resolveToken('a'), isNull);
        expect(notifier.resolveToken('b'), isNull);
      });

      test('detects longer circular reference (A -> B -> C -> A)', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create circular: A -> B -> C -> A
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'tokenA',
            type: TokenType.color,
            aliasOf: 'tokenB',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'tokenB',
            type: TokenType.color,
            aliasOf: 'tokenC',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'c',
            name: 'tokenC',
            type: TokenType.color,
            aliasOf: 'tokenA',
          ),
        );

        expect(notifier.hasCircularAlias('a'), true);
        expect(notifier.resolveToken('a'), isNull);
      });
    });

    group('Deep Alias Chain Warning', () {
      test('detects alias chain depth', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create chain of depth 4: A -> B -> C -> D (base)
        notifier.addToken(
          DesignToken.color(
            id: 'd',
            name: 'tokenD',
            lightValue: 0xFF000000,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'c',
            name: 'tokenC',
            type: TokenType.color,
            aliasOf: 'tokenD',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'tokenB',
            type: TokenType.color,
            aliasOf: 'tokenC',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'tokenA',
            type: TokenType.color,
            aliasOf: 'tokenB',
          ),
        );

        expect(notifier.getAliasChainDepth('a'), 3);
        expect(notifier.getAliasChainDepth('b'), 2);
        expect(notifier.getAliasChainDepth('c'), 1);
        expect(notifier.getAliasChainDepth('d'), 0);
      });

      test('warns on chains deeper than 3 levels', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create chain of depth 4
        notifier.addToken(
          DesignToken.color(
            id: 'e',
            name: 'tokenE',
            lightValue: 0xFF000000,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'd',
            name: 'tokenD',
            type: TokenType.color,
            aliasOf: 'tokenE',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'c',
            name: 'tokenC',
            type: TokenType.color,
            aliasOf: 'tokenD',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'tokenB',
            type: TokenType.color,
            aliasOf: 'tokenC',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'tokenA',
            type: TokenType.color,
            aliasOf: 'tokenB',
          ),
        );

        expect(notifier.isDeepAliasChain('a'), true); // Depth 4
        expect(notifier.isDeepAliasChain('b'), false); // Depth 3
        expect(notifier.isDeepAliasChain('c'), false); // Depth 2
      });
    });

    group('Convert to Value', () {
      test('converts alias to literal value', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create base and alias
        notifier.addToken(
          DesignToken.color(
            id: 'base-1',
            name: 'brandPrimary',
            lightValue: 0xFF0000FF,
            darkValue: 0xFF0000CC,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'alias-1',
            name: 'buttonBackground',
            type: TokenType.color,
            aliasOf: 'brandPrimary',
          ),
        );

        // Verify it's an alias
        var token = notifier.getTokenById('alias-1');
        expect(token?.isAlias, true);

        // Convert to value - this copies the resolved value
        final resolved = notifier.resolveToken('alias-1')!;
        final converted = DesignToken.color(
          id: 'alias-1',
          name: 'buttonBackground',
          lightValue: resolved.lightValue as int,
          darkValue: resolved.darkValue as int,
        );
        notifier.updateToken(converted);

        // Verify it's no longer an alias
        token = notifier.getTokenById('alias-1');
        expect(token?.isAlias, false);
        expect(token?.lightValue, 0xFF0000FF);
        expect(token?.darkValue, 0xFF0000CC);
      });

      test('converts spacing alias to literal value', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create base and alias
        notifier.addToken(
          DesignToken.spacing(
            id: 'base-1',
            name: 'basePadding',
            value: 16,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'alias-1',
            name: 'buttonPadding',
            type: TokenType.spacing,
            aliasOf: 'basePadding',
          ),
        );

        // Convert to value
        final resolved = notifier.resolveToken('alias-1')!;
        final converted = DesignToken.spacing(
          id: 'alias-1',
          name: 'buttonPadding',
          value: resolved.spacingValue!,
        );
        notifier.updateToken(converted);

        // Verify conversion
        final token = notifier.getTokenById('alias-1');
        expect(token?.isAlias, false);
        expect(token?.spacingValue, 16.0);
      });
    });

    group('Get Aliases Of Token', () {
      test('returns all tokens that alias a base token', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create base token
        notifier.addToken(
          DesignToken.color(
            id: 'base-1',
            name: 'brandPrimary',
            lightValue: 0xFF0000FF,
          ),
        );

        // Create multiple aliases
        notifier.addToken(
          DesignToken.alias(
            id: 'alias-1',
            name: 'buttonBackground',
            type: TokenType.color,
            aliasOf: 'brandPrimary',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'alias-2',
            name: 'headerBackground',
            type: TokenType.color,
            aliasOf: 'brandPrimary',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'alias-3',
            name: 'iconColor',
            type: TokenType.color,
            aliasOf: 'brandPrimary',
          ),
        );

        final aliases = notifier.getAliasesOf('brandPrimary');
        expect(aliases.length, 3);
        expect(
          aliases.map((t) => t.name),
          containsAll(['buttonBackground', 'headerBackground', 'iconColor']),
        );
      });
    });

    group('Alias Chain Visualization', () {
      test('builds alias chain from token to base', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create chain: A -> B -> C (base)
        notifier.addToken(
          DesignToken.color(
            id: 'c',
            name: 'tokenC',
            lightValue: 0xFF000000,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'tokenB',
            type: TokenType.color,
            aliasOf: 'tokenC',
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'a',
            name: 'tokenA',
            type: TokenType.color,
            aliasOf: 'tokenB',
          ),
        );

        final chain = notifier.getAliasChain('a');
        expect(chain.length, 3);
        expect(chain[0].name, 'tokenA');
        expect(chain[1].name, 'tokenB');
        expect(chain[2].name, 'tokenC');
      });

      test('returns single element for non-alias token', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(
          DesignToken.color(
            id: 'base-1',
            name: 'brandPrimary',
            lightValue: 0xFF0000FF,
          ),
        );

        final chain = notifier.getAliasChain('base-1');
        expect(chain.length, 1);
        expect(chain[0].name, 'brandPrimary');
      });
    });

    group('Circular Alias Prevention in UI', () {
      test('wouldCreateCircularAlias detects potential circular reference', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);

        // Create: B -> A (base)
        notifier.addToken(
          DesignToken.color(
            id: 'a',
            name: 'tokenA',
            lightValue: 0xFF000000,
          ),
        );
        notifier.addToken(
          DesignToken.alias(
            id: 'b',
            name: 'tokenB',
            type: TokenType.color,
            aliasOf: 'tokenA',
          ),
        );

        // Check if making A alias B would create circular
        expect(notifier.wouldCreateCircularAlias('a', 'tokenB'), true);
        expect(notifier.wouldCreateCircularAlias('a', 'tokenC'), false);
      });
    });
  });

  group('Alias UI Tests', () {
    testWidgets('shows alias indicator on alias tokens', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'base-1',
                  name: 'brandPrimary',
                  lightValue: 0xFF0000FF,
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'alias-1',
                  name: 'buttonBackground',
                  type: TokenType.color,
                  aliasOf: 'brandPrimary',
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find link icon (alias indicator)
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('alias form shows "Create as Alias" toggle', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'base-1',
                  name: 'brandPrimary',
                  lightValue: 0xFF0000FF,
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Add Token button
      await tester.tap(find.text('Add Token'));
      await tester.pumpAndSettle();

      // Should see "Create as Alias" toggle
      expect(find.text('Create as Alias'), findsOneWidget);
    });

    testWidgets('enabling alias shows token selector dropdown', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'base-1',
                  name: 'brandPrimary',
                  lightValue: 0xFF0000FF,
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Add Token
      await tester.tap(find.text('Add Token'));
      await tester.pumpAndSettle();

      // Toggle alias mode
      await tester.tap(find.byKey(const Key('alias_toggle')));
      await tester.pumpAndSettle();

      // Should see token selector
      expect(find.byKey(const Key('alias_target_dropdown')), findsOneWidget);
    });

    testWidgets('creating alias token shows in list with alias indicator',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'base-1',
                  name: 'brandPrimary',
                  lightValue: 0xFF0000FF,
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Add Token
      await tester.tap(find.text('Add Token'));
      await tester.pumpAndSettle();

      // Enable alias mode
      await tester.tap(find.byKey(const Key('alias_toggle')));
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(
        find.byKey(const Key('token_name_field')),
        'buttonBackground',
      );
      await tester.pumpAndSettle();

      // Select alias target
      await tester.tap(find.byKey(const Key('alias_target_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('brandPrimary').last);
      await tester.pumpAndSettle();

      // Create
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify alias indicator appears (now 2 tokens with alias indicator for the new one)
      expect(find.byIcon(Icons.link), findsOneWidget);
      expect(find.text('buttonBackground'), findsOneWidget);
      expect(find.text('Alias of brandPrimary'), findsOneWidget);
    });

    testWidgets('alias chain visualization shows in token details',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'c',
                  name: 'tokenC',
                  lightValue: 0xFF000000,
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'b',
                  name: 'tokenB',
                  type: TokenType.color,
                  aliasOf: 'tokenC',
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'a',
                  name: 'tokenA',
                  type: TokenType.color,
                  aliasOf: 'tokenB',
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on alias token to edit
      await tester.tap(find.text('tokenA'));
      await tester.pumpAndSettle();

      // Should show chain visualization
      expect(
        find.byKey(const Key('alias_chain_visualization')),
        findsOneWidget,
      );
      expect(find.text('tokenA'), findsWidgets);
      expect(find.text('tokenB'), findsWidgets);
      expect(find.text('tokenC'), findsWidgets);
    });

    testWidgets('shows deep chain warning for chains > 3 levels',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'e',
                  name: 'tokenE',
                  lightValue: 0xFF000000,
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'd',
                  name: 'tokenD',
                  type: TokenType.color,
                  aliasOf: 'tokenE',
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'c',
                  name: 'tokenC',
                  type: TokenType.color,
                  aliasOf: 'tokenD',
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'b',
                  name: 'tokenB',
                  type: TokenType.color,
                  aliasOf: 'tokenC',
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'a',
                  name: 'tokenA',
                  type: TokenType.color,
                  aliasOf: 'tokenB',
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Token A should have a warning icon for deep chain
      expect(
        find.byKey(const Key('deep_chain_warning_tokenA')),
        findsOneWidget,
      );
    });

    testWidgets('Convert to Value action appears for alias tokens',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'base-1',
                  name: 'brandPrimary',
                  lightValue: 0xFF0000FF,
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'alias-1',
                  name: 'buttonBackground',
                  type: TokenType.color,
                  aliasOf: 'brandPrimary',
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on alias token to edit
      await tester.tap(find.text('buttonBackground'));
      await tester.pumpAndSettle();

      // Should show "Convert to Value" button
      expect(find.text('Convert to Value'), findsOneWidget);
    });

    testWidgets('Convert to Value converts alias to literal', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              notifier.addToken(
                DesignToken.color(
                  id: 'base-1',
                  name: 'brandPrimary',
                  lightValue: 0xFF0000FF,
                  darkValue: 0xFF0000CC,
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'alias-1',
                  name: 'buttonBackground',
                  type: TokenType.color,
                  aliasOf: 'brandPrimary',
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially there's a link icon (alias indicator)
      expect(find.byIcon(Icons.link), findsOneWidget);

      // Tap on alias token
      await tester.tap(find.text('buttonBackground'));
      await tester.pumpAndSettle();

      // Tap Convert to Value
      await tester.tap(find.text('Convert to Value'));
      await tester.pumpAndSettle();

      // Should no longer show alias indicator
      expect(find.byIcon(Icons.link), findsNothing);

      // Should now show color hex value instead of "Alias of..."
      expect(find.text('Alias of brandPrimary'), findsNothing);
    });

    testWidgets('circular reference prevention shows no available tokens',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            designTokensProvider.overrideWith((ref) {
              final notifier = DesignTokensNotifier();
              // B -> A (so making A alias B would create circular)
              notifier.addToken(
                DesignToken.color(
                  id: 'a',
                  name: 'tokenA',
                  lightValue: 0xFF000000,
                ),
              );
              notifier.addToken(
                DesignToken.alias(
                  id: 'b',
                  name: 'tokenB',
                  type: TokenType.color,
                  aliasOf: 'tokenA',
                ),
              );
              return notifier;
            }),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: DesignSystemPanel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Edit tokenA (base token)
      await tester.tap(find.text('tokenA'));
      await tester.pumpAndSettle();

      // Enable alias mode
      await tester.tap(find.byKey(const Key('alias_toggle')));
      await tester.pumpAndSettle();

      // tokenB would create circular, so it's filtered out.
      // The only other token of same type would be tokenB, but that's
      // circular, so we should see "No tokens available to alias"
      expect(find.text('No tokens available to alias'), findsOneWidget);
    });
  });
}
