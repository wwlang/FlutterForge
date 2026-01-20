import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/properties/token_binding.dart';
import 'package:flutter_forge/features/properties/token_bindable_editors.dart';
import 'package:flutter_forge/features/properties/token_picker.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Token Application to Widgets (Task 3.5)', () {
    group('TokenBinding Model', () {
      test('creates binding from token name', () {
        const binding = TokenBinding(tokenName: 'primaryColor');

        expect(binding.tokenName, equals('primaryColor'));
        expect(binding.isBound, isTrue);
      });

      test('serializes to JSON with \$token key', () {
        const binding = TokenBinding(tokenName: 'primaryColor');
        final json = binding.toJson();

        expect(json, equals({'\$token': 'primaryColor'}));
      });

      test('deserializes from JSON with \$token key', () {
        final json = {'\$token': 'primaryColor'};
        final binding = TokenBinding.fromJson(json);

        expect(binding?.tokenName, equals('primaryColor'));
      });

      test('returns null for regular value (no binding)', () {
        final binding = TokenBinding.fromJson(0xFF0000FF);

        expect(binding, isNull);
      });

      test('detects token binding in map value', () {
        expect(
          TokenBinding.isTokenBound({'\$token': 'myToken'}),
          isTrue,
        );
        expect(TokenBinding.isTokenBound(0xFF0000FF), isFalse);
        expect(TokenBinding.isTokenBound(null), isFalse);
      });

      test('extracts token name from bound value', () {
        expect(
          TokenBinding.getTokenName({'\$token': 'myToken'}),
          equals('myToken'),
        );
        expect(TokenBinding.getTokenName(0xFF0000FF), isNull);
      });

      test('equality works correctly', () {
        const binding1 = TokenBinding(tokenName: 'primary');
        const binding2 = TokenBinding(tokenName: 'primary');
        const binding3 = TokenBinding(tokenName: 'secondary');

        expect(binding1 == binding2, isTrue);
        expect(binding1 == binding3, isFalse);
      });

      test('hashCode is consistent', () {
        const binding1 = TokenBinding(tokenName: 'primary');
        const binding2 = TokenBinding(tokenName: 'primary');

        expect(binding1.hashCode, equals(binding2.hashCode));
      });
    });

    group('Property Value Resolution', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        // Add test tokens
        notifier.addToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
          darkValue: 0xFF64B5F6,
        ));
        notifier.addToken(DesignToken.spacing(
          id: 'token-2',
          name: 'spacingMedium',
          value: 16.0,
        ));
        notifier.addToken(DesignToken.radius(
          id: 'token-3',
          name: 'radiusSmall',
          value: 8.0,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      test('resolves token binding to light value', () {
        final value = resolvePropertyValue(
          {'\$token': 'primaryColor'},
          TokenType.color,
          notifier,
          isDarkMode: false,
        );

        expect(value, equals(0xFF2196F3));
      });

      test('resolves token binding to dark value', () {
        final value = resolvePropertyValue(
          {'\$token': 'primaryColor'},
          TokenType.color,
          notifier,
          isDarkMode: true,
        );

        expect(value, equals(0xFF64B5F6));
      });

      test('resolves spacing token', () {
        final value = resolvePropertyValue(
          {'\$token': 'spacingMedium'},
          TokenType.spacing,
          notifier,
          isDarkMode: false,
        );

        expect(value, equals(16.0));
      });

      test('resolves radius token', () {
        final value = resolvePropertyValue(
          {'\$token': 'radiusSmall'},
          TokenType.radius,
          notifier,
          isDarkMode: false,
        );

        expect(value, equals(8.0));
      });

      test('returns literal value when not bound', () {
        final value = resolvePropertyValue(
          0xFF00FF00,
          TokenType.color,
          notifier,
          isDarkMode: false,
        );

        expect(value, equals(0xFF00FF00));
      });

      test('returns null for missing token', () {
        final value = resolvePropertyValue(
          {'\$token': 'nonExistent'},
          TokenType.color,
          notifier,
          isDarkMode: false,
        );

        expect(value, isNull);
      });

      test('resolves alias tokens', () {
        // Add an alias token
        notifier.addToken(DesignToken.alias(
          id: 'token-4',
          name: 'brandColor',
          type: TokenType.color,
          aliasOf: 'primaryColor',
        ));

        final value = resolvePropertyValue(
          {'\$token': 'brandColor'},
          TokenType.color,
          notifier,
          isDarkMode: false,
        );

        expect(value, equals(0xFF2196F3));
      });
    });

    group('Widget Node with Token Bindings', () {
      test('stores token binding in properties', () {
        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {
            'color': {'\$token': 'primaryColor'},
            'padding': 16.0,
          },
        );

        expect(
          TokenBinding.isTokenBound(node.properties['color']),
          isTrue,
        );
        expect(
          TokenBinding.isTokenBound(node.properties['padding']),
          isFalse,
        );
      });

      test('serializes and deserializes token bindings', () {
        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {
            'color': {'\$token': 'primaryColor'},
          },
        );

        final json = node.toJson();
        final restored = WidgetNode.fromJson(json);

        expect(
          TokenBinding.getTokenName(restored.properties['color']),
          equals('primaryColor'),
        );
      });

      test('handles multiple token bindings', () {
        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {
            'color': {'\$token': 'primaryColor'},
            'padding': {'\$token': 'spacingMedium'},
            'borderRadius': {'\$token': 'radiusSmall'},
          },
        );

        expect(TokenBinding.isTokenBound(node.properties['color']), isTrue);
        expect(TokenBinding.isTokenBound(node.properties['padding']), isTrue);
        expect(
            TokenBinding.isTokenBound(node.properties['borderRadius']), isTrue);
      });
    });

    group('TokenPicker Widget', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
        ));
        notifier.addToken(DesignToken.color(
          id: 'token-2',
          name: 'secondaryColor',
          lightValue: 0xFFFF5722,
        ));
        notifier.addToken(DesignToken.spacing(
          id: 'token-3',
          name: 'spacingMedium',
          value: 16.0,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      testWidgets('filters tokens by compatible type', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenPicker(
                  compatibleType: TokenType.color,
                  onTokenSelected: (_) {},
                ),
              ),
            ),
          ),
        );

        // Should show color tokens
        expect(find.text('primaryColor'), findsOneWidget);
        expect(find.text('secondaryColor'), findsOneWidget);

        // Should NOT show spacing tokens
        expect(find.text('spacingMedium'), findsNothing);
      });

      testWidgets('shows color preview for color tokens', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenPicker(
                  compatibleType: TokenType.color,
                  onTokenSelected: (_) {},
                ),
              ),
            ),
          ),
        );

        // Find color preview containers
        final colorPreviews = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color != null,
        );

        expect(colorPreviews, findsWidgets);
      });

      testWidgets('calls onTokenSelected when token tapped', (tester) async {
        DesignToken? selectedToken;

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenPicker(
                  compatibleType: TokenType.color,
                  onTokenSelected: (token) => selectedToken = token,
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('primaryColor'));
        await tester.pump();

        expect(selectedToken, isNotNull);
        expect(selectedToken!.name, equals('primaryColor'));
      });

      testWidgets('shows "No tokens" message when list empty', (tester) async {
        final emptyContainer = ProviderContainer();

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: emptyContainer,
            child: MaterialApp(
              home: Scaffold(
                body: TokenPicker(
                  compatibleType: TokenType.color,
                  onTokenSelected: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('No color tokens'), findsOneWidget);

        emptyContainer.dispose();
      });

      testWidgets('highlights currently selected token', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenPicker(
                  compatibleType: TokenType.color,
                  selectedTokenName: 'primaryColor',
                  onTokenSelected: (_) {},
                ),
              ),
            ),
          ),
        );

        // Find the list tile with selection indicator
        final selectedTile = find.byWidgetPredicate(
          (widget) => widget is ListTile && widget.selected == true,
        );

        expect(selectedTile, findsOneWidget);
      });

      testWidgets('shows spacing token picker', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenPicker(
                  compatibleType: TokenType.spacing,
                  onTokenSelected: (_) {},
                ),
              ),
            ),
          ),
        );

        // Should show spacing tokens
        expect(find.text('spacingMedium'), findsOneWidget);
        // Should NOT show color tokens
        expect(find.text('primaryColor'), findsNothing);
      });
    });

    group('TokenBindableColorEditor Widget', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      testWidgets('shows "Use Token" button for color property',
          (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: 0xFF00FF00,
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
      });

      testWidgets('shows token name when bound', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: {'\$token': 'primaryColor'},
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('primaryColor'), findsOneWidget);
      });

      testWidgets('shows "Clear Token" action when bound', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: {'\$token': 'primaryColor'},
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        // Clear button should be visible
        expect(find.byIcon(Icons.link_off), findsOneWidget);
      });

      testWidgets('calls onTokenBound when token selected', (tester) async {
        String? boundToken;

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: 0xFF00FF00,
                  onChanged: (_) {},
                  onTokenBound: (token) => boundToken = token,
                ),
              ),
            ),
          ),
        );

        // Tap the token button to open picker
        await tester.tap(find.byIcon(Icons.palette_outlined));
        await tester.pumpAndSettle();

        // Select a token
        await tester.tap(find.text('primaryColor'));
        await tester.pumpAndSettle();

        expect(boundToken, equals('primaryColor'));
      });

      testWidgets('calls onChanged with resolved value when clearing token',
          (tester) async {
        dynamic changedValue;

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: {'\$token': 'primaryColor'},
                  onChanged: (v) => changedValue = v,
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        // Tap clear button
        await tester.tap(find.byIcon(Icons.link_off));
        await tester.pump();

        // Should convert to literal value
        expect(changedValue, equals(0xFF2196F3));
      });

      testWidgets('displays color preview box', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: 0xFF00FF00,
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        // Find color preview container
        final colorPreview = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color ==
                  const Color(0xFF00FF00),
        );

        expect(colorPreview, findsOneWidget);
      });
    });

    group('TokenBindableDoubleEditor Widget', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(DesignToken.spacing(
          id: 'token-1',
          name: 'spacingMedium',
          value: 16.0,
        ));
        notifier.addToken(DesignToken.radius(
          id: 'token-2',
          name: 'radiusSmall',
          value: 8.0,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      testWidgets('shows token button for spacing property', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableDoubleEditor(
                  propertyName: 'padding',
                  displayName: 'Padding',
                  tokenType: TokenType.spacing,
                  value: 8.0,
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
      });

      testWidgets('filters by token type', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableDoubleEditor(
                  propertyName: 'padding',
                  displayName: 'Padding',
                  tokenType: TokenType.spacing,
                  value: 8.0,
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        // Open picker
        await tester.tap(find.byIcon(Icons.palette_outlined));
        await tester.pumpAndSettle();

        // Should show spacing tokens
        expect(find.text('spacingMedium'), findsOneWidget);
        // Should NOT show radius tokens
        expect(find.text('radiusSmall'), findsNothing);
      });

      testWidgets('shows token name when bound', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableDoubleEditor(
                  propertyName: 'padding',
                  displayName: 'Padding',
                  tokenType: TokenType.spacing,
                  value: {'\$token': 'spacingMedium'},
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('spacingMedium'), findsOneWidget);
      });

      testWidgets('shows clear button when bound', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableDoubleEditor(
                  propertyName: 'padding',
                  displayName: 'Padding',
                  tokenType: TokenType.spacing,
                  value: {'\$token': 'spacingMedium'},
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.link_off), findsOneWidget);
      });
    });

    group('Token Change Propagation', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      test('resolved value updates when token changes', () {
        final binding = {'\$token': 'primaryColor'};

        // Initial value
        var resolved = resolvePropertyValue(
          binding,
          TokenType.color,
          notifier,
          isDarkMode: false,
        );
        expect(resolved, equals(0xFF2196F3));

        // Update the token
        notifier.updateToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFFFF0000,
        ));

        // Resolved value should reflect the change
        resolved = resolvePropertyValue(
          binding,
          TokenType.color,
          notifier,
          isDarkMode: false,
        );
        expect(resolved, equals(0xFFFF0000));
      });
    });

    group('Tooltip for Bound Properties', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      testWidgets('shows resolved value in tooltip', (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(
                body: TokenBindableColorEditor(
                  propertyName: 'color',
                  displayName: 'Color',
                  value: {'\$token': 'primaryColor'},
                  onChanged: (_) {},
                  onTokenBound: (_) {},
                ),
              ),
            ),
          ),
        );

        // Find tooltip widget
        final tooltips = tester.widgetList<Tooltip>(find.byType(Tooltip));
        expect(tooltips.isNotEmpty, isTrue);

        // Verify tooltip message contains hex value
        final resolvedTooltip =
            tooltips.firstWhere((t) => (t.message ?? "").contains("Resolved"));
        expect(resolvedTooltip.message, contains('2196F3'));
      });
    });

    group('Helper Functions', () {
      late ProviderContainer container;
      late DesignTokensNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(designTokensProvider.notifier);

        notifier.addToken(DesignToken.color(
          id: 'token-1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
          darkValue: 0xFF64B5F6,
        ));
        notifier.addToken(DesignToken.spacing(
          id: 'token-2',
          name: 'spacingMedium',
          value: 16.0,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      test('resolveColorTokenValue returns color for light mode', () {
        final value = resolveColorTokenValue(
          'primaryColor',
          notifier,
          isDarkMode: false,
        );
        expect(value, equals(0xFF2196F3));
      });

      test('resolveColorTokenValue returns color for dark mode', () {
        final value = resolveColorTokenValue(
          'primaryColor',
          notifier,
          isDarkMode: true,
        );
        expect(value, equals(0xFF64B5F6));
      });

      test('resolveDoubleTokenValue returns spacing value', () {
        final value = resolveDoubleTokenValue(
          'spacingMedium',
          TokenType.spacing,
          notifier,
        );
        expect(value, equals(16.0));
      });

      test('resolveColorTokenValue returns null for missing token', () {
        final value = resolveColorTokenValue(
          'nonExistent',
          notifier,
          isDarkMode: false,
        );
        expect(value, isNull);
      });

      test('resolveDoubleTokenValue returns null for missing token', () {
        final value = resolveDoubleTokenValue(
          'nonExistent',
          TokenType.spacing,
          notifier,
        );
        expect(value, isNull);
      });
    });
  });
}
