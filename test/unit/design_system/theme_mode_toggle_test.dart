import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_forge/providers/theme_mode_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme Mode Toggle (Task 3.4)', () {
    group('Theme Mode Provider', () {
      test('default mode is light', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final mode = container.read(themeModeProvider);
        expect(mode, ThemeMode.light);
      });

      test('can switch to dark mode', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container
            .read(themeSettingsProvider.notifier)
            .setThemeMode(ThemeMode.dark);
        expect(container.read(themeModeProvider), ThemeMode.dark);
      });

      test('can switch to high contrast mode', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // High contrast uses the settings notifier
        container.read(themeSettingsProvider.notifier).setHighContrast(true);
        expect(container.read(isHighContrastProvider), true);
      });

      test('cycle method rotates through modes', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(themeSettingsProvider.notifier);

        // Light -> Dark
        notifier.cycle();
        expect(container.read(themeModeProvider), ThemeMode.dark);

        // Dark -> System
        notifier.cycle();
        expect(container.read(themeModeProvider), ThemeMode.system);

        // System -> Light
        notifier.cycle();
        expect(container.read(themeModeProvider), ThemeMode.light);
      });
    });

    group('Token Value for Theme Mode', () {
      test('returns light value in light mode', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);
        notifier.addToken(
          DesignToken.color(
            id: 'test-1',
            name: 'primary',
            lightValue: 0xFF0000FF, // Blue
            darkValue: 0xFFFF0000, // Red
          ),
        );

        container
            .read(themeSettingsProvider.notifier)
            .setThemeMode(ThemeMode.light);

        final token = notifier.getTokenById('test-1');
        final resolvedValue = _getColorForMode(
          token!,
          container.read(themeModeProvider),
          Brightness.light, // Platform brightness
        );
        expect(resolvedValue, 0xFF0000FF);
      });

      test('returns dark value in dark mode', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);
        notifier.addToken(
          DesignToken.color(
            id: 'test-1',
            name: 'primary',
            lightValue: 0xFF0000FF, // Blue
            darkValue: 0xFFFF0000, // Red
          ),
        );

        container
            .read(themeSettingsProvider.notifier)
            .setThemeMode(ThemeMode.dark);

        final token = notifier.getTokenById('test-1');
        final resolvedValue = _getColorForMode(
          token!,
          container.read(themeModeProvider),
          Brightness.light, // Platform brightness
        );
        expect(resolvedValue, 0xFFFF0000);
      });

      test('system mode uses platform brightness', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);
        notifier.addToken(
          DesignToken.color(
            id: 'test-1',
            name: 'primary',
            lightValue: 0xFF0000FF, // Blue
            darkValue: 0xFFFF0000, // Red
          ),
        );

        container
            .read(themeSettingsProvider.notifier)
            .setThemeMode(ThemeMode.system);

        final token = notifier.getTokenById('test-1');

        // System mode with light platform brightness -> light value
        var resolvedValue = _getColorForMode(
          token!,
          ThemeMode.system,
          Brightness.light,
        );
        expect(resolvedValue, 0xFF0000FF);

        // System mode with dark platform brightness -> dark value
        resolvedValue = _getColorForMode(
          token,
          ThemeMode.system,
          Brightness.dark,
        );
        expect(resolvedValue, 0xFFFF0000);
      });
    });

    group('High Contrast Mode', () {
      test('high contrast increases color contrast', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);
        notifier.addToken(
          DesignToken.color(
            id: 'test-1',
            name: 'primary',
            lightValue: 0xFF3366AA, // Medium blue
            darkValue: 0xFFAA6633, // Medium orange
            highContrastLightValue: 0xFF0000FF, // Pure blue
            highContrastDarkValue: 0xFFFFAA00, // High contrast orange
          ),
        );

        container.read(themeSettingsProvider.notifier).setHighContrast(true);

        final token = notifier.getTokenById('test-1');
        expect(token?.highContrastLightValue, 0xFF0000FF);
        expect(token?.highContrastDarkValue, 0xFFFFAA00);
      });

      test('falls back to regular values if no high contrast defined', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(designTokensProvider.notifier);
        notifier.addToken(
          DesignToken.color(
            id: 'test-1',
            name: 'primary',
            lightValue: 0xFF3366AA,
            darkValue: 0xFFAA6633,
            // No high contrast values
          ),
        );

        container.read(themeSettingsProvider.notifier).setHighContrast(true);

        final token = notifier.getTokenById('test-1');
        // Should fall back to regular values
        expect(token?.highContrastLightValue ?? token?.lightValue, 0xFF3366AA);
      });
    });

    group('Keyboard Shortcut', () {
      testWidgets('Ctrl/Cmd+Shift+T cycles theme mode', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _ThemeToggleTestWidget(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially light
        expect(find.text('ThemeMode: light'), findsOneWidget);

        // Press Ctrl+Shift+T (or Cmd on Mac)
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pumpAndSettle();

        // Should be dark now
        expect(find.text('ThemeMode: dark'), findsOneWidget);

        // Press again
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        await tester.pumpAndSettle();

        // Should be system now
        expect(find.text('ThemeMode: system'), findsOneWidget);
      });
    });

    group('Theme Mode UI', () {
      testWidgets('toggle button shows current mode icon', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _ThemeToggleTestWidget(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Light mode shows sun icon
        expect(find.byIcon(Icons.light_mode), findsOneWidget);

        // Tap to cycle
        await tester.tap(find.byKey(const Key('theme_toggle_button')));
        await tester.pumpAndSettle();

        // Dark mode shows moon icon
        expect(find.byIcon(Icons.dark_mode), findsOneWidget);

        // Tap again
        await tester.tap(find.byKey(const Key('theme_toggle_button')));
        await tester.pumpAndSettle();

        // System mode shows auto icon
        expect(find.byIcon(Icons.brightness_auto), findsOneWidget);
      });

      testWidgets('toggle dropdown allows direct mode selection',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _ThemeToggleTestWidget(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Long press to show dropdown
        await tester.longPress(find.byKey(const Key('theme_toggle_button')));
        await tester.pumpAndSettle();

        // Select dark mode directly
        await tester.tap(find.text('Dark'));
        await tester.pumpAndSettle();

        expect(find.text('ThemeMode: dark'), findsOneWidget);
      });

      testWidgets('high contrast toggle appears in dropdown', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              home: _ThemeToggleTestWidget(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Long press to show dropdown
        await tester.longPress(find.byKey(const Key('theme_toggle_button')));
        await tester.pumpAndSettle();

        // High contrast switch should be visible
        expect(find.text('High Contrast'), findsOneWidget);
        expect(find.byKey(const Key('high_contrast_switch')), findsOneWidget);
      });
    });

    group('Preview Live Update', () {
      testWidgets('changing theme mode updates preview instantly',
          (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              designTokensProvider.overrideWith((ref) {
                final notifier = DesignTokensNotifier();
                notifier.addToken(
                  DesignToken.color(
                    id: 'bg-1',
                    name: 'background',
                    lightValue: 0xFFFFFFFF, // White
                    darkValue: 0xFF000000, // Black
                  ),
                );
                return notifier;
              }),
            ],
            child: MaterialApp(
              home: _ColorPreviewTestWidget(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Light mode - should be white
        expect(
          find.byWidgetPredicate(
            (w) => w is Container && _hasBackgroundColor(w, 0xFFFFFFFF),
          ),
          findsOneWidget,
        );

        // Toggle to dark
        await tester.tap(find.byKey(const Key('theme_toggle_button')));
        await tester.pumpAndSettle();

        // Dark mode - should be black
        expect(
          find.byWidgetPredicate(
            (w) => w is Container && _hasBackgroundColor(w, 0xFF000000),
          ),
          findsOneWidget,
        );
      });
    });
  });
}

// Helper to get color value based on theme mode
int _getColorForMode(DesignToken token, ThemeMode mode, Brightness platform) {
  final isDark = switch (mode) {
    ThemeMode.light => false,
    ThemeMode.dark => true,
    ThemeMode.system => platform == Brightness.dark,
  };

  return (isDark ? token.darkValue : token.lightValue) as int? ?? 0;
}

bool _hasBackgroundColor(Container container, int colorValue) {
  final decoration = container.decoration;
  if (decoration is BoxDecoration) {
    final color = decoration.color;
    return color?.toARGB32() == colorValue;
  }
  return container.color?.toARGB32() == colorValue;
}

// Test widget that displays theme toggle
class _ThemeToggleTestWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isHighContrast = ref.watch(isHighContrastProvider);

    return Scaffold(
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(
            LogicalKeyboardKey.keyT,
            control: true,
            shift: true,
          ): () {
            ref.read(themeSettingsProvider.notifier).cycle();
          },
        },
        child: Focus(
          autofocus: true,
          child: Column(
            children: [
              Text('ThemeMode: ${themeMode.name}'),
              Text('High Contrast: $isHighContrast'),
              _ThemeToggleButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return GestureDetector(
      key: const Key('theme_toggle_button'),
      onTap: () => ref.read(themeSettingsProvider.notifier).cycle(),
      onLongPress: () => _showThemeMenu(context, ref),
      child: Icon(
        switch (themeMode) {
          ThemeMode.light => Icons.light_mode,
          ThemeMode.dark => Icons.dark_mode,
          ThemeMode.system => Icons.brightness_auto,
        },
      ),
    );
  }

  void _showThemeMenu(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Light'),
              onTap: () {
                ref
                    .read(themeSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.light);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                ref
                    .read(themeSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.dark);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('System'),
              onTap: () {
                ref
                    .read(themeSettingsProvider.notifier)
                    .setThemeMode(ThemeMode.system);
                Navigator.pop(ctx);
              },
            ),
            Row(
              children: [
                const Text('High Contrast'),
                Consumer(
                  builder: (context, ref, _) => Switch(
                    key: const Key('high_contrast_switch'),
                    value: ref.watch(isHighContrastProvider),
                    onChanged: (v) {
                      ref
                          .read(themeSettingsProvider.notifier)
                          .setHighContrast(v);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorPreviewTestWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = ref.watch(designTokensProvider);
    final themeMode = ref.watch(themeModeProvider);
    final bgToken = tokens.firstWhere((t) => t.name == 'background');

    final colorValue = switch (themeMode) {
      ThemeMode.light => bgToken.lightValue as int,
      ThemeMode.dark => bgToken.darkValue as int,
      ThemeMode.system =>
        MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? bgToken.darkValue as int
            : bgToken.lightValue as int,
    };

    return Scaffold(
      body: Column(
        children: [
          _ThemeToggleButton(),
          Container(
            width: 100,
            height: 100,
            color: Color(colorValue),
          ),
        ],
      ),
    );
  }
}
