import 'package:flutter_forge/core/models/design_token.dart';
import 'package:flutter_forge/core/models/widget_node.dart';
import 'package:flutter_forge/features/design_system/style_preset.dart';
import 'package:flutter_forge/providers/design_tokens_provider.dart';
import 'package:flutter_forge/providers/style_presets_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Style Presets (Task 3.6)', () {
    group('StylePreset Model', () {
      test('creates preset with multiple properties', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Primary Button',
          category: PresetCategory.button,
          properties: {
            'backgroundColor': {r'$token': 'primaryColor'},
            'borderRadius': {r'$token': 'radiusMedium'},
            'padding': 16.0,
          },
        );

        expect(preset.id, equals('preset-1'));
        expect(preset.name, equals('Primary Button'));
        expect(preset.category, equals(PresetCategory.button));
        expect(preset.properties.length, equals(3));
      });

      test('serializes to JSON', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Card Style',
          category: PresetCategory.container,
          properties: {
            'backgroundColor': 0xFFFFFFFF,
            'elevation': 4.0,
          },
        );

        final json = preset.toJson();

        expect(json['id'], equals('preset-1'));
        expect(json['name'], equals('Card Style'));
        expect(json['category'], equals('container'));
        expect(json['properties'], isA<Map<String, dynamic>>());
        expect(json['properties']['backgroundColor'], equals(0xFFFFFFFF));
      });

      test('deserializes from JSON', () {
        final json = {
          'id': 'preset-2',
          'name': 'Danger Button',
          'category': 'button',
          'properties': {
            'backgroundColor': {r'$token': 'dangerColor'},
            'textColor': {r'$token': 'onDangerColor'},
          },
        };

        final preset = StylePreset.fromJson(json);

        expect(preset.id, equals('preset-2'));
        expect(preset.name, equals('Danger Button'));
        expect(preset.category, equals(PresetCategory.button));
        expect(
            preset.properties['backgroundColor'], isA<Map<String, dynamic>>());
      });

      test('copyWith creates modified copy', () {
        final original = StylePreset(
          id: 'preset-1',
          name: 'Original',
          category: PresetCategory.container,
          properties: {'color': 0xFF000000},
        );

        final modified = original.copyWith(name: 'Modified');

        expect(modified.id, equals('preset-1'));
        expect(modified.name, equals('Modified'));
        expect(modified.properties, equals(original.properties));
      });

      test('supports description field', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Subtle Card',
          category: PresetCategory.container,
          properties: {'elevation': 1.0},
          description: 'Low elevation card for subtle UI',
        );

        expect(preset.description, equals('Low elevation card for subtle UI'));
      });
    });

    group('PresetCategory', () {
      test('all categories are defined', () {
        expect(PresetCategory.values, contains(PresetCategory.button));
        expect(PresetCategory.values, contains(PresetCategory.container));
        expect(PresetCategory.values, contains(PresetCategory.text));
        expect(PresetCategory.values, contains(PresetCategory.input));
        expect(PresetCategory.values, contains(PresetCategory.layout));
      });

      test('category serialization', () {
        expect(PresetCategory.button.name, equals('button'));
        expect(PresetCategory.container.name, equals('container'));
      });
    });

    group('StylePresetsNotifier', () {
      late ProviderContainer container;
      late StylePresetsNotifier notifier;

      setUp(() {
        container = ProviderContainer();
        notifier = container.read(stylePresetsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('starts empty', () {
        final presets = container.read(stylePresetsProvider);
        expect(presets, isEmpty);
      });

      test('adds preset', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Test Preset',
          category: PresetCategory.button,
          properties: {'color': 0xFF0000FF},
        );

        notifier.addPreset(preset);

        final presets = container.read(stylePresetsProvider);
        expect(presets.length, equals(1));
        expect(presets.first.name, equals('Test Preset'));
      });

      test('removes preset', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Test Preset',
          category: PresetCategory.button,
          properties: {},
        );

        notifier.addPreset(preset);
        notifier.removePreset('preset-1');

        final presets = container.read(stylePresetsProvider);
        expect(presets, isEmpty);
      });

      test('updates preset', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Original',
          category: PresetCategory.button,
          properties: {},
        );

        notifier.addPreset(preset);
        notifier.updatePreset(preset.copyWith(name: 'Updated'));

        final presets = container.read(stylePresetsProvider);
        expect(presets.first.name, equals('Updated'));
      });

      test('filters by category', () {
        notifier.addPreset(StylePreset(
          id: 'p1',
          name: 'Button Style',
          category: PresetCategory.button,
          properties: {},
        ));
        notifier.addPreset(StylePreset(
          id: 'p2',
          name: 'Card Style',
          category: PresetCategory.container,
          properties: {},
        ));
        notifier.addPreset(StylePreset(
          id: 'p3',
          name: 'Primary Button',
          category: PresetCategory.button,
          properties: {},
        ));

        final buttonPresets = notifier.getByCategory(PresetCategory.button);

        expect(buttonPresets.length, equals(2));
        expect(buttonPresets.every((p) => p.category == PresetCategory.button),
            isTrue);
      });

      test('gets preset by id', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Test Preset',
          category: PresetCategory.button,
          properties: {},
        );

        notifier.addPreset(preset);

        final found = notifier.getById('preset-1');
        expect(found, isNotNull);
        expect(found!.name, equals('Test Preset'));
      });

      test('returns null for missing preset', () {
        final found = notifier.getById('nonexistent');
        expect(found, isNull);
      });
    });

    group('Applying Presets to Widgets', () {
      late ProviderContainer container;
      // ignore: unused_local_variable
      late StylePresetsNotifier presetsNotifier;

      setUp(() {
        container = ProviderContainer();
        presetsNotifier = container.read(stylePresetsProvider.notifier);
      });

      tearDown(() {
        container.dispose();
      });

      test('applies all preset properties to widget', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Card Style',
          category: PresetCategory.container,
          properties: {
            'backgroundColor': 0xFFFFFFFF,
            'borderRadius': 8.0,
            'elevation': 4.0,
          },
        );

        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'width': 100.0},
        );

        final result = applyPresetToWidget(preset, node);

        expect(result.properties['backgroundColor'], equals(0xFFFFFFFF));
        expect(result.properties['borderRadius'], equals(8.0));
        expect(result.properties['elevation'], equals(4.0));
        expect(result.properties['width'], equals(100.0));
      });

      test('preset properties override widget properties', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Style',
          category: PresetCategory.container,
          properties: {'color': 0xFF0000FF},
        );

        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'color': 0xFFFF0000},
        );

        final result = applyPresetToWidget(preset, node);

        expect(result.properties['color'], equals(0xFF0000FF));
      });

      test('applies with token bindings preserved', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Themed Style',
          category: PresetCategory.container,
          properties: {
            'backgroundColor': {r'$token': 'surfaceColor'},
          },
        );

        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
        );

        final result = applyPresetToWidget(preset, node);

        expect(
            result.properties['backgroundColor'], isA<Map<String, dynamic>>());
        expect(
          (result.properties['backgroundColor'] as Map)[r'$token'],
          equals('surfaceColor'),
        );
      });

      test('tracks applied preset on widget', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Style',
          category: PresetCategory.container,
          properties: {'color': 0xFF0000FF},
        );

        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
        );

        final result = applyPresetToWidget(preset, node);

        expect(result.appliedPresetId, equals('preset-1'));
      });
    });

    group('Preset Overrides', () {
      test('allows overriding preset property', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Base Style',
          category: PresetCategory.container,
          properties: {
            'backgroundColor': 0xFFFFFFFF,
            'borderRadius': 8.0,
          },
        );

        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
          appliedPresetId: 'preset-1',
        );

        // Apply preset first
        var result = applyPresetToWidget(preset, node);

        // Override specific property
        result = overridePresetProperty(
          result,
          'backgroundColor',
          0xFF000000,
        );

        expect(result.properties['backgroundColor'], equals(0xFF000000));
        expect(result.propertyOverrides, contains('backgroundColor'));
        expect(result.appliedPresetId, equals('preset-1'));
      });

      test('tracks multiple overrides', () {
        var node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {
            'backgroundColor': 0xFFFFFFFF,
            'borderRadius': 8.0,
          },
          appliedPresetId: 'preset-1',
        );

        node = overridePresetProperty(node, 'backgroundColor', 0xFF000000);
        node = overridePresetProperty(node, 'borderRadius', 16.0);

        expect(node.propertyOverrides, contains('backgroundColor'));
        expect(node.propertyOverrides, contains('borderRadius'));
        expect(node.propertyOverrides.length, equals(2));
      });

      test('clears override restores preset value', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Style',
          category: PresetCategory.container,
          properties: {'color': 0xFFFFFFFF},
        );

        var node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {'color': 0xFF000000},
          appliedPresetId: 'preset-1',
          propertyOverrides: ['color'],
        );

        node = clearPropertyOverride(node, 'color', preset);

        expect(node.properties['color'], equals(0xFFFFFFFF));
        expect(node.propertyOverrides, isNot(contains('color')));
      });

      test('detaching preset keeps current values', () {
        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {
            'backgroundColor': 0xFF000000,
            'borderRadius': 16.0,
          },
          appliedPresetId: 'preset-1',
          propertyOverrides: ['backgroundColor'],
        );

        final result = detachPreset(node);

        expect(result.appliedPresetId, isNull);
        expect(result.propertyOverrides, isEmpty);
        expect(result.properties['backgroundColor'], equals(0xFF000000));
        expect(result.properties['borderRadius'], equals(16.0));
      });
    });

    group('Preset and Token Integration', () {
      late ProviderContainer container;
      late DesignTokensNotifier tokensNotifier;
      // ignore: unused_local_variable
      late StylePresetsNotifier presetsNotifier;

      setUp(() {
        container = ProviderContainer();
        tokensNotifier = container.read(designTokensProvider.notifier);
        presetsNotifier = container.read(stylePresetsProvider.notifier);

        // Set up tokens
        tokensNotifier.addToken(DesignToken.color(
          id: 't1',
          name: 'primaryColor',
          lightValue: 0xFF2196F3,
        ));
        tokensNotifier.addToken(DesignToken.radius(
          id: 't2',
          name: 'radiusMedium',
          value: 12.0,
        ));
      });

      tearDown(() {
        container.dispose();
      });

      test('preset with token references resolves correctly', () {
        final preset = StylePreset(
          id: 'preset-1',
          name: 'Primary Card',
          category: PresetCategory.container,
          properties: {
            'backgroundColor': {r'$token': 'primaryColor'},
            'borderRadius': {r'$token': 'radiusMedium'},
          },
        );

        final node = WidgetNode(
          id: 'node-1',
          type: 'Container',
          properties: {},
        );

        final result = applyPresetToWidget(preset, node);

        // Properties should store token references
        expect(
            result.properties['backgroundColor'], isA<Map<String, dynamic>>());
        expect(result.properties['borderRadius'], isA<Map<String, dynamic>>());

        // Token references are preserved for code generation
        expect(
          (result.properties['backgroundColor'] as Map)[r'$token'],
          equals('primaryColor'),
        );
      });
    });

    group('Built-in Presets', () {
      test('provides default button presets', () {
        final presets = getBuiltInPresets();

        final buttonPresets =
            presets.where((p) => p.category == PresetCategory.button).toList();

        expect(buttonPresets, isNotEmpty);
        expect(
          buttonPresets.any((p) => p.name.toLowerCase().contains('primary')),
          isTrue,
        );
      });

      test('provides default container presets', () {
        final presets = getBuiltInPresets();

        final containerPresets = presets
            .where((p) => p.category == PresetCategory.container)
            .toList();

        expect(containerPresets, isNotEmpty);
      });

      test('built-in presets have valid properties', () {
        final presets = getBuiltInPresets();

        for (final preset in presets) {
          expect(preset.id, isNotEmpty);
          expect(preset.name, isNotEmpty);
          expect(preset.properties, isNotNull);
        }
      });
    });
  });
}
