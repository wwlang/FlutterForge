import 'package:flutter/material.dart';
import 'package:flutter_forge/core/models/forge_project.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/code_preview/code_preview_settings.dart';
import 'package:flutter_forge/features/code_preview/dart_version_indicator.dart';
import 'package:flutter_forge/generators/dart_generator.dart';
import 'package:flutter_forge/providers/code_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Task 9.1.3: Dart Version Targeting Tests (J19 S3)
///
/// Tests for:
/// - Export settings for Dart version target
/// - Dart 3.9 compatibility mode (no shorthand)
/// - Version indicator in code panel
/// - Version setting persistence in project
void main() {
  group('Task 9.1.3: Dart Version Targeting (J19 S3)', () {
    group('CodeSettings Model', () {
      test('CodeSettings defaults to Dart 3.10 with shorthand enabled', () {
        const settings = CodeSettings();

        expect(settings.dartVersion, DartVersion.dart310);
        expect(settings.useDotShorthand, isTrue);
      });

      test('CodeSettings with Dart 3.9 disables shorthand', () {
        const settings = CodeSettings(dartVersion: DartVersion.dart39);

        expect(settings.dartVersion, DartVersion.dart39);
        // Note: useDotShorthand field may still be true, but effectiveShorthand
        // should be false because Dart 3.9 doesn't support it
        expect(settings.effectiveShorthand, isFalse);
      });

      test('CodeSettings can be serialized to JSON', () {
        const settings = CodeSettings();
        final json = settings.toJson();

        expect(json['dartVersion'], 'dart310');
        expect(json['useDotShorthand'], true);
      });

      test('CodeSettings can be deserialized from JSON', () {
        final json = {'dartVersion': 'dart39', 'useDotShorthand': false};
        final settings = CodeSettings.fromJson(json);

        expect(settings.dartVersion, DartVersion.dart39);
        expect(settings.useDotShorthand, isFalse);
      });

      test('effectiveShorthand respects Dart version', () {
        // 3.10 with shorthand enabled (default)
        const enabled = CodeSettings();
        expect(enabled.effectiveShorthand, isTrue);

        // 3.10 with shorthand disabled
        const disabled = CodeSettings(useDotShorthand: false);
        expect(disabled.effectiveShorthand, isFalse);

        // 3.9 ignores shorthand setting
        const legacy = CodeSettings(dartVersion: DartVersion.dart39);
        expect(legacy.effectiveShorthand, isFalse);
      });
    });

    group('DartVersion Enum', () {
      test('DartVersion values include dart39 and dart310', () {
        expect(DartVersion.values, contains(DartVersion.dart39));
        expect(DartVersion.values, contains(DartVersion.dart310));
      });

      test('DartVersion has display names', () {
        expect(DartVersion.dart39.displayName, 'Dart 3.9 (Legacy)');
        expect(DartVersion.dart310.displayName, 'Dart 3.10+ (Shorthand)');
      });

      test('DartVersion has short names', () {
        expect(DartVersion.dart39.shortName, 'Dart 3.9');
        expect(DartVersion.dart310.shortName, 'Dart 3.10+');
      });

      test('DartVersion has min SDK constraints', () {
        expect(DartVersion.dart39.minSdkConstraint, '^3.9.0');
        expect(DartVersion.dart310.minSdkConstraint, '^3.10.0');
      });

      test('DartVersion knows shorthand support', () {
        expect(DartVersion.dart39.supportsShorthand, isFalse);
        expect(DartVersion.dart310.supportsShorthand, isTrue);
      });
    });

    group('CodeSettingsProvider', () {
      test('provides default settings', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final settings = container.read(codeSettingsProvider);

        expect(settings.dartVersion, DartVersion.dart310);
        expect(settings.useDotShorthand, isTrue);
      });

      test('settings can be updated', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(codeSettingsProvider.notifier).setDartVersion(
              DartVersion.dart39,
            );

        final settings = container.read(codeSettingsProvider);
        expect(settings.dartVersion, DartVersion.dart39);
        // Shorthand should be disabled for 3.9
        expect(settings.useDotShorthand, isFalse);
      });

      test('toggling shorthand manually is allowed for 3.10+', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Start with 3.10
        expect(container.read(codeSettingsProvider).useDotShorthand, isTrue);

        // Disable shorthand manually
        container.read(codeSettingsProvider.notifier).setDotShorthand(
              enabled: false,
            );

        expect(container.read(codeSettingsProvider).useDotShorthand, isFalse);
      });

      test('shorthand is always false for Dart 3.9', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Set to 3.9
        container.read(codeSettingsProvider.notifier).setDartVersion(
              DartVersion.dart39,
            );

        // Try to enable shorthand
        container.read(codeSettingsProvider.notifier).setDotShorthand(
              enabled: true,
            );

        // Should still be false
        expect(container.read(codeSettingsProvider).useDotShorthand, isFalse);
      });

      test('reset returns to default settings', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Change settings
        container.read(codeSettingsProvider.notifier).setDartVersion(
              DartVersion.dart39,
            );

        // Reset
        container.read(codeSettingsProvider.notifier).reset();

        final settings = container.read(codeSettingsProvider);
        expect(settings.dartVersion, DartVersion.dart310);
        expect(settings.useDotShorthand, isTrue);
      });

      test('loadFromMetadata sets correct version', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Load dart39
        container.read(codeSettingsProvider.notifier).loadFromMetadata(
              'dart39',
            );

        var settings = container.read(codeSettingsProvider);
        expect(settings.dartVersion, DartVersion.dart39);

        // Load dart310
        container.read(codeSettingsProvider.notifier).loadFromMetadata(
              'dart310',
            );

        settings = container.read(codeSettingsProvider);
        expect(settings.dartVersion, DartVersion.dart310);

        // Load null defaults to dart310
        container.read(codeSettingsProvider.notifier).loadFromMetadata(null);

        settings = container.read(codeSettingsProvider);
        expect(settings.dartVersion, DartVersion.dart310);
      });
    });

    group('Code Generation Integration', () {
      late DartGenerator generator;

      setUp(() {
        generator = DartGenerator();
      });

      test('generates shorthand code when settings enable it', () {
        const settings = CodeSettings();

        final code = generator.generate(
          nodes: {
            'root': _createRowNode(
              mainAxisAlignment: 'MainAxisAlignment.center',
            ),
          },
          rootId: 'root',
          className: 'TestWidget',
          useDotShorthand: settings.effectiveShorthand,
        );

        expect(code, contains('.center'));
        expect(code, isNot(contains('MainAxisAlignment.center')));
      });

      test('generates legacy code when settings disable it', () {
        const settings = CodeSettings(dartVersion: DartVersion.dart39);

        final code = generator.generate(
          nodes: {
            'root': _createRowNode(
              mainAxisAlignment: 'MainAxisAlignment.center',
            ),
          },
          rootId: 'root',
          className: 'TestWidget',
          useDotShorthand: settings.effectiveShorthand,
        );

        expect(code, contains('MainAxisAlignment.center'));
      });

      test('generates legacy code when shorthand manually disabled', () {
        const settings = CodeSettings(useDotShorthand: false);

        final code = generator.generate(
          nodes: {
            'root': _createRowNode(
              mainAxisAlignment: 'MainAxisAlignment.center',
            ),
          },
          rootId: 'root',
          className: 'TestWidget',
          useDotShorthand: settings.effectiveShorthand,
        );

        expect(code, contains('MainAxisAlignment.center'));
      });
    });

    group('Project Persistence', () {
      test('ProjectMetadata stores non-default dart version', () {
        final metadata = ProjectMetadata(
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          forgeVersion: '1.0.0',
          targetDartVersion: 'dart39',
        );

        expect(metadata.targetDartVersion, 'dart39');
      });

      test('ProjectMetadata defaults to dart310', () {
        final metadata = ProjectMetadata(
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          forgeVersion: '1.0.0',
        );

        expect(metadata.targetDartVersion, 'dart310');
      });

      test('CodeSettings can be derived from ProjectMetadata', () {
        final metadata = ProjectMetadata(
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          forgeVersion: '1.0.0',
          targetDartVersion: 'dart39',
        );

        final settings = CodeSettings.fromProjectMetadata(metadata);

        expect(settings.dartVersion, DartVersion.dart39);
        expect(settings.effectiveShorthand, isFalse);
      });

      test('ProjectMetadata serializes dart version to JSON', () {
        final metadata = ProjectMetadata(
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          forgeVersion: '1.0.0',
          targetDartVersion: 'dart39',
        );

        final json = metadata.toJson();
        expect(json['targetDartVersion'], 'dart39');
      });

      test('ProjectMetadata deserializes dart version from JSON', () {
        final json = {
          'createdAt': DateTime.now().toIso8601String(),
          'modifiedAt': DateTime.now().toIso8601String(),
          'forgeVersion': '1.0.0',
          'targetDartVersion': 'dart39',
        };

        final metadata = ProjectMetadata.fromJson(json);
        expect(metadata.targetDartVersion, 'dart39');
      });
    });
  });

  group('DartVersionIndicator Widget', () {
    testWidgets('displays current Dart version', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DartVersionIndicator(),
            ),
          ),
        ),
      );

      // Default is Dart 3.10+
      expect(find.text('Dart 3.10+'), findsOneWidget);
    });

    testWidgets('shows dropdown on tap', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DartVersionIndicator(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DartVersionIndicator));
      await tester.pumpAndSettle();

      // Should show version options
      expect(find.text('Dart 3.9 (Legacy)'), findsOneWidget);
      expect(find.text('Dart 3.10+ (Shorthand)'), findsOneWidget);
    });

    testWidgets('shows shorthand toggle', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DartVersionIndicator(),
            ),
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(DartVersionIndicator));
      await tester.pumpAndSettle();

      // Should show shorthand toggle
      expect(find.text('Use dot shorthand'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('has code icon', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DartVersionIndicator(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.code), findsOneWidget);
    });
  });
}

/// Helper to create a Row WidgetNode for testing.
WidgetNode _createRowNode({required String mainAxisAlignment}) {
  return WidgetNode(
    id: 'root',
    type: 'Row',
    properties: {'mainAxisAlignment': mainAxisAlignment},
    childrenIds: [],
  );
}
